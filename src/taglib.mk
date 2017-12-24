# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := taglib
$(PKG)_WEBSITE  := https://developer.kde.org/~wheeler/taglib.html
$(PKG)_DESCR    := TagLib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.10
$(PKG)_CHECKSUM := 24c32d50042cb0ddf162eb263f8ac75c5a158e12bf32ed534c1d5c71ee369baa
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://taglib.github.io/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, taglib/taglib, v)
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' .. \
        -DENABLE_STATIC=$(CMAKE_STATIC_BOOL)
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
