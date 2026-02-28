# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pystring
$(PKG)_WEBSITE  := https://github.com/imageworks/pystring
$(PKG)_DESCR    := Header-only C++ string library inspired by Python
$(PKG)_VERSION  := 1.1.4
$(PKG)_CHECKSUM := 49da0fe2a049340d3c45cce530df63a2278af936003642330287b68cefd788fb
$(PKG)_GH_CONF  := imageworks/pystring/tags,v
$(PKG)_SUBDIR   := pystring-$($(PKG)_VERSION)
$(PKG)_TARGETS  := $(TARGET)
$(PKG)_DEPS     :=

define $(PKG)_BUILD
    mkdir -p '$(PREFIX)/$(TARGET)/include/pystring'
    cp -v '$(SOURCE_DIR)'/*.h '$(PREFIX)/$(TARGET)/include/pystring/'
endef
