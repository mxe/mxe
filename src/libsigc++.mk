# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsigc++
$(PKG)_WEBSITE  := https://libsigc.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.3
$(PKG)_CHECKSUM := 0b68dfc6313c6cc90ac989c6d722a1bf0585ad13846e79746aa87cb265904786
$(PKG)_GH_CONF  := libsigcplusplus/libsigcplusplus/releases,,,99,,.tar.xz
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_URL_2    := https://download.gnome.org/sources/libsigc++/$(call SHORT_PKG_VERSION,$(PKG))/libsigc++-$($(PKG)_VERSION).tar.xz
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        CXX='$(TARGET)-g++' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)
endef
