# This file is part of MXE.
# See index.html for further information.

PKG             := shogun
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.1
$(PKG)_CHECKSUM := c1048ab21e8548457d3f7fec2800a65db959f202
$(PKG)_SUBDIR   := $(PKG)-$(PKG)_$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)_$($(PKG)_VERSION).zip
$(PKG)_URL      := https://github.com/$(PKG)-toolbox/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/shogun-toolbox/shogun/tags' | \
    $(SED) -n 's,.*<span class="tag-name">\([0-9.]*\)</span>.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && mkdir build && cd build && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DEIGEN_BUILD_PKGCONFIG=ON \
        -Drun_res=1 -Drun_res__TRYRUN_OUTPUT=""
    $(MAKE) -C '$(1)'/build -j '$(JOBS)' install VERBOSE=1
endef
