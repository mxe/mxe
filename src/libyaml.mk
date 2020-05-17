# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libyaml
$(PKG)_WEBSITE  := https://github.com/yaml/libyaml
$(PKG)_DESCR    := A C library for parsing and emitting YAML.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.4
$(PKG)_CHECKSUM := 02265e0229675aea3a413164b43004045617174bdb2c92bf6782f618f8796b55
$(PKG)_GH_CONF  := yaml/libyaml/releases/latest
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
	cd '$(SOURCE_DIR)' && ./bootstrap
	cd '$(BUILD_DIR)' && \
		$(SOURCE_DIR)/configure \
		$(MXE_CONFIGURE_OPTS)
	$(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
	$(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
