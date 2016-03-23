# This file is part of MXE.
# See index.html for further information.

PKG             := googletest
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.0
$(PKG)_CHECKSUM := f73a6546fdf9fce9ff93a5015e0333a8af3062a152a9ad6bcb772c96687016cc
$(PKG)_SUBDIR   := $(PKG)-release-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/google/$(PKG)/archive/release-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, google/googletest, release-)
endef
