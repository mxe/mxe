# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libyaml
$(PKG)_WEBSITE  := https://github.com/yaml/libyaml
$(PKG)_DESCR    := A C library for parsing and emitting YAML.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.5
$(PKG)_CHECKSUM := fa240dbf262be053f3898006d502d514936c818e422afdcf33921c63bed9bf2e
$(PKG)_GH_CONF  := yaml/libyaml/releases/latest
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && ./bootstrap
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS)
endef
