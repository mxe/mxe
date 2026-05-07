# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := meson
$(PKG)_WEBSITE  := https://mesonbuild.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11.1
$(PKG)_CHECKSUM := 6788ae299979643f8d841bcaf64352558436cae45a0355148a3aeeccf7913866
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
