# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsigc++
$(PKG)_WEBSITE  := https://libsigc.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.0
$(PKG)_CHECKSUM := 7593d5fa9187bbad7c6868dce375ce3079a805f3f1e74236143bceb15a37cd30
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
