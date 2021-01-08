# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := check
$(PKG)_WEBSITE  := https://libcheck.github.io/check/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.15.2
$(PKG)_CHECKSUM := a8de4e0bacfb4d76dd1c618ded263523b53b85d92a146d8835eb1a52932fa20a
$(PKG)_GH_CONF  := libcheck/check/releases/latest
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_TESTING=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
