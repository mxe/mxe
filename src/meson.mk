# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := meson
$(PKG)_WEBSITE  := https://mesonbuild.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.0
$(PKG)_CHECKSUM := d9616c44cd6c53689ff8f05fc6958a693f2e17c3472a8daf83cee55dabff829f
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
