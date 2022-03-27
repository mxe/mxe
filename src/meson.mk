# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := meson
$(PKG)_WEBSITE  := https://mesonbuild.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.61.2
$(PKG)_CHECKSUM := 0233a7f8d959079318f6052b0939c27f68a5de86ba601f25c9ee6869fb5f5889
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
