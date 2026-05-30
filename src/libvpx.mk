# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libvpx
$(PKG)_WEBSITE  := https://www.webmproject.org/code/
$(PKG)_DESCR    := vpx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16.0
$(PKG)_CHECKSUM := 7a479a3c66b9f5d5542a4c6a1b7d3768a983b1e5c14c60a9396edc9b649e015c
$(PKG)_GH_CONF  := webmproject/libvpx/tags,v
$(PKG)_DEPS     := cc pthreads yasm

define $(PKG)_BUILD
    $(SED) -i 's,yasm[ $$],$(TARGET)-yasm ,g' '$(1)/build/make/configure.sh'
    cd '$(1)' && \
        CROSS='$(TARGET)-' \
        ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --target=@libvpx-target@ \
        --disable-examples \
        --disable-install-docs \
        --as=$(TARGET)-yasm
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(TARGET)-ranlib $(PREFIX)/$(TARGET)/lib/libvpx.a
endef

$(PKG)_BUILD_i686-w64-mingw32   = $(subst @libvpx-target@,x86-win32-gcc,$($(PKG)_BUILD))
$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @libvpx-target@,x86_64-win64-gcc,$($(PKG)_BUILD))
