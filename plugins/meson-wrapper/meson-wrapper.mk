# This file is part of MXE. See LICENSE.md for licensing information.

PKG              := meson-wrapper
$(PKG)_VERSION   := 1
$(PKG)_UPDATE    := echo 1
$(PKG)_TARGETS   := $(MXE_TARGETS)
$(PKG)_FILE_DEPS := $(wildcard $(PWD)/plugins/meson-wrapper/conf/*)
$(PKG)_DEPS      := cmake-conf

define $(PKG)_BUILD
    # create the Meson cross file
    mkdir -p '$(PREFIX)/$(TARGET)/share/meson/mxe-conf.d'
    cmake-configure-file \
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
        -DINPUT='$(PWD)/plugins/meson-wrapper/conf/mxe-crossfile.meson.in' \
        -DOUTPUT='$(PREFIX)/$(TARGET)/share/meson/mxe-crossfile.meson'

    # create the prefixed Meson wrapper script
    cmake-configure-file \
        -DLIBTYPE=$(if $(BUILD_SHARED),shared,static) \
        -DPREFIX=$(PREFIX) \
        -DTARGET=$(TARGET) \
        -DBUILD=$(BUILD) \
        -DMESON_CROSS_FILE='$(PREFIX)/$(TARGET)/share/meson/mxe-crossfile.meson' \
        -DINPUT='$(PWD)/plugins/meson-wrapper/conf/target-meson.in' \
        -DOUTPUT='$(PREFIX)/bin/$(TARGET)-meson'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-meson'
endef
