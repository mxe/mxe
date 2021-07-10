# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := c-ares
$(PKG)_WEBSITE  := https://github.com/c-ares/c-ares
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.15.0
$(PKG)_CHECKSUM := 7deb7872cbd876c29036d5f37e30c4cbc3cc068d59d8b749ef85bb0736649f04
$(PKG)_GH_CONF  := c-ares/c-ares/tags,cares-,,,_
$(PKG)_DEPS     := cc $(BUILD)~$(PKG)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := libtool

define $(PKG)_CONFIGURE # cmake
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        $(if $(BUILD_STATIC),-DCARES_STATIC=ON -DCARES_SHARED=OFF) \
        $(if $(BUILD_SHARED),-DCARES_STATIC=OFF -DCARES_SHARED=ON) \
        $(PKG_CMAKE_OPTS)
endef

define $(PKG)_MAKE
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
endef

define $(PKG)_INSTALL
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef

define $(PKG)_BUILD_$(BUILD) # simple
    cd '$(SOURCE_DIR)' && '$(SOURCE_DIR)'/buildconf
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)'/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef

define $(PKG)_BUILD
    $($(PKG)_CONFIGURE)
    $($(PKG)_MAKE)
    $($(PKG)_INSTALL)
endef
