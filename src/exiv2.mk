# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Exiv2
PKG             := exiv2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.19
$(PKG)_CHECKSUM := 4ab8d830094f2842bc286d8e7fb03100ca7f07b1
$(PKG)_SUBDIR   := exiv2-$($(PKG)_VERSION)
$(PKG)_FILE     := exiv2-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.exiv2.org/
$(PKG)_URL      := http://www.exiv2.org/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv zlib expat

define $(PKG)_UPDATE
    wget -q -O- 'http://www.exiv2.org/download.html' | \
    grep 'href="exiv2-' | \
    $(SED) -n 's,.*exiv2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # workaround for the missing snprintf() in the <cstdio> of GCC-4.4.0
    $(SED) -i 's,#include <cstdio>,#include <stdio.h>,' '$(1)/xmpsdk/src/XMPMeta.cpp'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-visibility \
        --disable-nls \
        --with-expat
    $(MAKE) -C '$(1)/xmpsdk/src' -j '$(JOBS)'
    $(MAKE) -C '$(1)/src'        -j '$(JOBS)' install-lib
endef
