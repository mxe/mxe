# This file is part of MXE.
# See index.html for further information.

PKG             := libvpx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.0
$(PKG)_CHECKSUM := 01dac42fffd20b59ebaec5ec1d2f10b991d5ce63
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/webmproject/libvpx/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads yasm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/webmproject/libvpx/releases' | \
    $(SED) -n 's,.*v\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,yasm[ $$],$(TARGET)-yasm ,g' '$(1)/build/make/configure.sh'
    cd '$(1)' && \
        CROSS='$(TARGET)-' \
        ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --target=@libvpx-target@ \
        --disable-examples \
        --disable-install-docs \
        --as=$(TARGET)-yasm \
        --extra-cflags='-std=gnu89'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(TARGET)-ranlib $(PREFIX)/$(TARGET)/lib/libvpx.a
endef

$(PKG)_BUILD_i686-w64-mingw32   = $(subst @libvpx-target@,x86-win32-gcc,$($(PKG)_BUILD))
$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @libvpx-target@,x86_64-win64-gcc,$($(PKG)_BUILD))
