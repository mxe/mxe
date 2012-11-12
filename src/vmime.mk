# This file is part of MXE.
# See index.html for further information.

PKG             := vmime
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 24a32dcc2eaf78d4a53541936ef72e4cf4f0a6ff
$(PKG)_SUBDIR   := kisli-vmime-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/kisli/vmime/tarball/$($(PKG)_VERSION)/$(PKG)_FILE
$(PKG)_DEPS     := gcc libiconv gnutls libgsasl pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/kisli/vmime/commits/master' | \
    $(SED) -n 's#.*<span class="sha">\([^<]\{7\}\)[^<]\{3\}<.*#\1#p' | \
    head -1
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
