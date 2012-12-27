# This file is part of MXE.
# See index.html for further information.

PKG             := libvpx
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 356af5f770c50cd021c60863203d8f30164f6021
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://webm.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://code.google.com/p/webm/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*libvpx-v\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        CROSS='$(TARGET)-' \
        ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --target=libvpx-target \
        --disable-examples \
        --disable-install-docs
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(TARGET)-ranlib $(PREFIX)/$(TARGET)/lib/libvpx.a
endef

$(PKG)_BUILD_i686-static-mingw32    = $(subst libvpx-target ,x86-win32-gcc ,$($(PKG)_BUILD))
$(PKG)_BUILD_x86_64-static-mingw32  = $(subst libvpx-target ,x86_64-win64-gcc ,$($(PKG)_BUILD))
$(PKG)_BUILD_i686-dynamic-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-dynamic-mingw32 = $($(PKG)_BUILD)
