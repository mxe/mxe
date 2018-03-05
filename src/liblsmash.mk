# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := liblsmash
$(PKG)_WEBSITE  := https://l-smash.github.io/l-smash/
$(PKG)_DESCR    := L-SMASH
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9.1
$(PKG)_CHECKSUM := 17f24fc8bffba753f8c628f1732fc3581b80362341274747ef6fb96af1cac45c
$(PKG)_SUBDIR   := l-smash-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/l-smash/l-smash/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, l-smash/l-smash, v)
endef

# L-SMASH uses a custom made configure script that doesn't recognize
# the option --host and fails on unknown options.
# Therefor $(MXE_CONFIGURE_OPTS) can't be used here.
define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --cross-prefix=$(TARGET)- \
        $(if $(BUILD_SHARED), --enable-shared --disable-static)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
