# This file is part of MXE.
# See index.html for further information.

PKG             := libraw
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.17.1
$(PKG)_CHECKSUM := c7e81ada5f73277b748351f0361fa16afff924ab403b76173cb5744149ba75bb
$(PKG)_SUBDIR   := LibRaw-$($(PKG)_VERSION)
$(PKG)_FILE     := LibRaw-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://files.kde.org/krita/build/dependencies//$($(PKG)_FILE)
$(PKG)_DEPS     := gcc tiff xz jpeg lcms

define $(PKG)_UPDATE

endef

define $(PKG)_BUILD

    cd '$(1)' && mkdir build && cd build && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DEIGEN_BUILD_PKGCONFIG=ON \
        -Drun_res=1 -Drun_res__TRYRUN_OUTPUT=""
    $(MAKE) -C '$(1)'/build -j '$(JOBS)' install VERBOSE=1

endef
