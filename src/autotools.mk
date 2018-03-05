# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := autotools
$(PKG)_WEBSITE  := https://en.wikipedia.org/wiki/GNU_Build_System
$(PKG)_DESCR    := Dependency package to ensure the autotools work
$(PKG)_VERSION  := 1
$(PKG)_DEPS     := libtool pkgconf
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_TYPE     := meta
