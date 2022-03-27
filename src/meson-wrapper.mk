# This file is part of MXE. See LICENSE.md for licensing information.

PKG              := meson-wrapper
$(PKG)_VERSION   := 1
$(PKG)_UPDATE    := echo 1
$(PKG)_FILE_DEPS := $(wildcard $(PWD)/src/meson-wrapper/conf/*)
$(PKG)_TARGETS   := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS      := cmake-conf $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := cmake-conf meson

# Ensure `make meson` installs meson wrapper too

meson: meson-wrapper

define $(PKG)_BUILD
    # create the Meson cross files (common and internal-only)
    mkdir -p '$(PREFIX)/$(TARGET)/share/meson/mxe-conf.d'

    '$(PREFIX)/bin/cmake-configure-file' \
        -DLIBTYPE=$(if $(BUILD_SHARED),shared,static) \
        -DPREFIX=$(PREFIX) \
        -DTARGET=$(TARGET) \
        -DBUILD=$(BUILD) \
        -DCPU_FAMILY=$(strip \
             $(if $(findstring x86_64,$(TARGET)),x86_64,\
             $(if $(findstring i686,$(TARGET)),x86))) \
        -DCPU=$(strip \
             $(if $(findstring x86_64,$(TARGET)),x86_64,\
             $(if $(findstring i686,$(TARGET)),i686))) \
        -DINPUT='$(PWD)/src/meson-wrapper/conf/mxe-crossfile.meson.in' \
        -DOUTPUT='$(PREFIX)/$(TARGET)/share/meson/mxe-crossfile.meson'

    '$(PREFIX)/bin/cmake-configure-file' \
        -DLIBTYPE=$(if $(BUILD_SHARED),shared,static) \
        -DPREFIX=$(PREFIX) \
        -DTARGET=$(TARGET) \
        -DBUILD=$(BUILD) \
        -DINPUT='$(PWD)/src/meson-wrapper/conf/mxe-crossfile-internal.meson.in' \
        -DOUTPUT='$(PREFIX)/$(TARGET)/share/meson/mxe-crossfile-internal.meson'

    # create the prefixed Meson wrapper script
    '$(PREFIX)/bin/cmake-configure-file' \
        -DLIBTYPE=$(if $(BUILD_SHARED),shared,static) \
        -DPREFIX=$(PREFIX) \
        -DTARGET=$(TARGET) \
        -DBUILD=$(BUILD) \
        -DMESON_EXECUTABLE=$(PREFIX)/$(BUILD)/bin/meson \
        -DMESON_CROSS_FILE='$(PREFIX)/$(TARGET)/share/meson/mxe-crossfile.meson' \
        -DINPUT='$(PWD)/src/meson-wrapper/conf/target-meson.in' \
        -DOUTPUT='$(PREFIX)/bin/$(TARGET)-meson'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-meson'
endef

define $(PKG)_BUILD_$(BUILD)
    # create the prefixed Meson wrapper script for native builds
    '$(PREFIX)/bin/cmake-configure-file' \
        -DLIBTYPE=$(if $(BUILD_SHARED),shared,static) \
        -DPREFIX=$(PREFIX) \
        -DBUILD=$(BUILD) \
        -DMESON_EXECUTABLE=$(PREFIX)/$(BUILD)/bin/meson \
        -DINPUT='$(PWD)/src/meson-wrapper/conf/native-meson.in' \
        -DOUTPUT='$(PREFIX)/bin/mxe-native-meson'
    chmod 0755 '$(PREFIX)/bin/mxe-native-meson'
endef
