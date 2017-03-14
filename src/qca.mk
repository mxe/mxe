# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qca
$(PKG)_WEBSITE  := https://userbase.kde.org/QCA
$(PKG)_DESCR    := Qt Cryptographic Architecture
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.3
$(PKG)_CHECKSUM := a5135ffb0250a40e9c361eb10cd3fe28293f0cf4e5c69d3761481eafd7968067
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/KDE/qca/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/KDE/qca/tags' | \
    $(SED) -n 's,.*/KDE/qca/archive/v\([0-9][^>]*\)\.tar\.gz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_TESTS=OFF \
        -DBUILD_TOOLS=OFF \
        -DUSE_RELATIVE_PATHS=OFF \
        -DBUILD_PLUGINS="auto" \
        -DQCA_MAN_INSTALL_DIR="$(BUILD_DIR)/null"
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
