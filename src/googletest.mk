# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := googletest
$(PKG)_WEBSITE  := https://github.com/google/googletest
$(PKG)_DESCR    := Google Test
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.0
$(PKG)_CHECKSUM := f73a6546fdf9fce9ff93a5015e0333a8af3062a152a9ad6bcb772c96687016cc
$(PKG)_GH_CONF  := google/googletest/tags, release-
$(PKG)_DEPS     :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_TYPE     := source-only
