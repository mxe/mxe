# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# VMime
PKG             := vmime
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.0
$(PKG)_CHECKSUM := 02215e1d8ea758f486c32e7bff63a04f71a9b736
$(PKG)_SUBDIR   := libvmime-$($(PKG)_VERSION)
$(PKG)_FILE     := libvmime-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://vmime.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/vmime/vmime/0.9/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv gnutls libgsasl

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/vmime/files/vmime/) | \
    $(SED) -n 's,.*vmime-\([0-9][^>]*\)\.tar\.bz2.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
      --prefix='$(PREFIX)/$(TARGET)' \
      --host='$(TARGET)' \
      --disable-shared \
      --enable-platform-windows \
      --disable-rpath \
      --disable-dependency-tracking

    # Add the missing "a" suffix for the library.
    # Otherwise, we get a "libvmime.la" that refers to "libvimime."
    $(SED) 's/^libext=$$/libext=a/;' -i '$(1)/libtool'

    # Disable VMIME_HAVE_MLANG_H
    # We have the header, but there is no implementation for IMultiLanguage in MinGW
    $(SED) 's,^#define VMIME_HAVE_MLANG_H 1$$,,' -i '$(1)/vmime/config.hpp'

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' install
endef
