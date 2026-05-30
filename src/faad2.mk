# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := faad2
$(PKG)_WEBSITE  := https://github.com/knik0/faad2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.11.2
$(PKG)_CHECKSUM := 3fcbd305e4abd34768c62050e18ca0986f7d9c5eca343fb98275418013065c0e
$(PKG)_GH_CONF  := knik0/faad2/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
