# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := googletest
$(PKG)_WEBSITE  := https://github.com/google/googletest
$(PKG)_DESCR    := Google Test
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.1
$(PKG)_CHECKSUM := 9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c
$(PKG)_GH_CONF  := google/googletest/tags, release-
$(PKG)_DEPS     :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_TYPE     := source-only
