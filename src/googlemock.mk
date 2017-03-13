# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := googlemock
$(PKG)_WEBSITE  := https://github.com/google/googlemock
$(PKG)_DESCR    := Google Mock
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.0
$(PKG)_CHECKSUM := 3f20b6acb37e5a98e8c4518165711e3e35d47deb6cdb5a4dd4566563b5efd232
$(PKG)_SUBDIR   := googlemock-release-$($(PKG)_VERSION)
$(PKG)_FILE     := googlemock-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/google/googlemock/archive/release-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, google/googlemock, release-)
endef
