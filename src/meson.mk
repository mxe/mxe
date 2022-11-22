# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := meson
$(PKG)_WEBSITE  := https://mesonbuild.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.64.1
$(PKG)_CHECKSUM := 3a8e030c2334f782085f81627062cc6d4a6771edf31e055ffe374f9e6b089ab9
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
