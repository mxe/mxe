# This file is part of MXE.
# See index.html for further information.

PKG             := box2d
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := d323141a9bb202e37f9860568ca0769be67e4758e6bbccb4f190fdf50cc7bf4e
$(PKG)_DEPS     := gcc

$(PKG)_GH_REPO    := erincatto/Box2D
$(PKG)_GH_TAG_PFX := v
$(PKG)_GH_TAG_SHA := b20eb82
$(eval $(MXE_SETUP_GITHUB))

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBOX2D_INSTALL=ON \
        -DBOX2D_BUILD_EXAMPLES=OFF \
        -DBOX2D_BUILD_STATIC=$(CMAKE_STATIC_BOOL) \
        -DBOX2D_BUILD_SHARED=$(CMAKE_SHARED_BOOL) \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef
