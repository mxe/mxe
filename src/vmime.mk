# This file is part of MXE.
# See index.html for further information.

PKG             := vmime
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3e8dd8855e423db438d465777efeb523c4abb5f3
$(PKG)_SUBDIR   := lib$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := lib$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv gnutls libgsasl pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/vmime/files/vmime/' | \
    $(SED) -n 's,.*libvmime-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's/pkg-config/$(TARGET)-pkg-config/g;'  '$(1)/SConstruct'

    # The configure script will make the real configuration, but
    # we need scons to generate configure.in, Makefile.am etc.
    cd '$(1)' && scons autotools \
         prefix='$(PREFIX)/$(TARGET)' \
         target='$(TARGET)' \
         sendmail_path=/sbin/sendmail

    cd '$(1)' && ./bootstrap
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-platform-windows \
        --disable-rpath \
        --disable-dependency-tracking

    # Disable VMIME_HAVE_MLANG_H
    # We have the header, but there is no implementation for IMultiLanguage in MinGW
    $(SED) -i 's,^#define VMIME_HAVE_MLANG_H 1$$,,' '$(1)/vmime/config.hpp'

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' install

    $(SED) -i 's/posix/windows/g;' '$(1)/examples/example6.cpp'
    $(TARGET)-g++ -s -o '$(1)/examples/test-vmime.exe' \
        '$(1)/examples/example6.cpp' \
        `'$(TARGET)-pkg-config' vmime --cflags --libs`
    $(INSTALL) -m755 '$(1)/examples/test-vmime.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
