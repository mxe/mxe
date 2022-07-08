# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := meson
$(PKG)_WEBSITE  := https://mesonbuild.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.63.0
$(PKG)_CHECKSUM := 3b51d451744c2bc71838524ec8d96cd4f8c4793d5b8d5d0d0a9c8a4f7c94cd6f
$(PKG)_GH_CONF  := mesonbuild/meson/releases
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS_$(BUILD) := ninja

define $(PKG)_BUILD_$(BUILD)
    # Use Meson's ability to install as a single file
    '$(PYTHON3)' '$(SOURCE_DIR)/packaging/create_zipapp.py' \
                 --outfile '$(PREFIX)/$(TARGET)/bin/meson' \
                 --interpreter '$(PYTHON3)' \
                 '$(SOURCE_DIR)'
endef
