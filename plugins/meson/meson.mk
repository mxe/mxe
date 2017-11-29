# This file is part of MXE. See LICENSE.md for licensing information.

PKG              := meson
$(PKG)_WEBSITE   := https://mesonbuild.com/
$(PKG)_DESCR     := An open source build system meant to be extremely fast and as user friendly as possible.
$(PKG)_IGNORE    :=
$(PKG)_VERSION   := 0.43.0
$(PKG)_CHECKSUM  := 324894427dcd29f6156fe06b046c6ad1b998470714debd7c5705902f21aaaa73
$(PKG)_GH_CONF   := mesonbuild/meson/releases/latest
$(PKG)_SUBDIR    := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE      := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL       := https://github.com/mesonbuild/meson/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_FILE_DEPS := $(wildcard $(PWD)/plugins/meson/conf/*)
$(PKG)_DEPS      := python3-conf ninja
$(PKG)_TARGETS   := $(BUILD) $(MXE_TARGETS)

define $(PKG)_BUILD
    # create the Meson cross file
    mkdir -p '$(PREFIX)/$(TARGET)/share/meson'
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
        -DINPUT='$(PWD)/plugins/meson/conf/mxe-crossfile.meson.in' \
        -DOUTPUT='$(PREFIX)/$(TARGET)/share/meson/mxe-crossfile.meson'

    # create the prefixed Meson wrapper script
    cmake-configure-file \
        -DPATH='$(PREFIX)/$(BUILD)/bin:$(PREFIX)/bin' \
        -DLIBTYPE=$(if $(BUILD_SHARED),shared,static) \
        -DPREFIX=$(PREFIX) \
        -DTARGET=$(TARGET) \
        -DBUILD=$(BUILD) \
        -DMESON_CROSS_FILE='$(PREFIX)/$(TARGET)/share/meson/mxe-crossfile.meson' \
        -DINPUT='$(PWD)/plugins/meson/conf/target-meson.in' \
        -DOUTPUT='$(PREFIX)/bin/$(TARGET)-meson'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-meson'
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(SOURCE_DIR)' && python3 setup.py install \
        --prefix='$(PREFIX)/$(TARGET)' && \
    $(SED) -i 's,^#!/usr/bin/python3,#!/usr/bin/env python3,' \
        '$(PREFIX)/$(TARGET)/bin/meson'
endef
