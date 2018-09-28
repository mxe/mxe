# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := drmingw
$(PKG)_WEBSITE  := https://github.com/jrfonseca/drmingw
$(PKG)_DESCR    := Postmortem debugging tools for MinGW
$(PKG)_VERSION  := 0.8.2
$(PKG)_CHECKSUM := cbb26e513a8faf0393d2d60319da944ef963e592919c4f92990c5e2752fa9d26
$(PKG)_GH_CONF  := jrfonseca/drmingw/releases/latest
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
