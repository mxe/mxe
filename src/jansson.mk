# This file is part of MXE.
# See index.html for further information.

PKG             := jansson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 19da8ce0b6b018e6b02d0b893c1ced0e713aadb2
$(PKG)_CHECKSUM := 0f0f818af0bfa5e07c4ddcc7a4e0ded9c4e62caf
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/akheron/jansson/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc autoconf automake libtool

$(PKG)_UPDATE = $(call MXE_GET_GITHUB_TAG_SHA, akheron/jansson)

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix '$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
