# This file is part of MXE.
# See index.html for further information.

PKG             := muparserx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := v3_0_3
$(PKG)_CHECKSUM := d476899a024b6b720591484f615464dc1eb25b23
$(PKG)_SUBDIR   :=
$(PKG)_FILE     := $(PKG)_v3_0_2.zip
$(PKG)_URL      := http://muparserx.googlecode.com/svn/archives/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
echo "TODO: write update for muparserx"
endef

define $(PKG)_BUILD
    mkdir '$(1)$(PKG)_$($(PKG)_VERSION).build'
    cd '$(1)$(PKG)_$($(PKG)_VERSION).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),FALSE,TRUE) \
	-DCMAKE_CXX_FLAGS='-std=c++11' \
        '$(1)$(PKG)_$($(PKG)_VERSION)'
	$(MAKE) -C '$(1)$(PKG)_$($(PKG)_VERSION).build' install
endef
