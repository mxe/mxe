# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ricochet
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.4
$(PKG)_CHECKSUM := f5f32caa3480def1de5c93010c6bf5f5789ddcba34bf09fc0feab67696d0c374
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_URL      := https://ricochet.im/releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://ricochet.im/
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_DEPS     := cc openssl protobuf qtbase qtdeclarative qtmultimedia qtquickcontrols qttools

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, ricochet-im/ricochet, v)
endef

define $(PKG)_BUILD
    # TODO: add libasan and libubsan and let ricochet use them.
    # See https://github.com/ricochet-im/ricochet/blob/master/BUILDING.md#hardening
    cd '$(BUILD_DIR)' && \
        '$(TARGET)-qmake-qt5' \
        OPENSSLDIR='$(PREFIX)/$(TARGET)' \
        PROTOBUFDIR='$(PREFIX)/$(TARGET)' \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    cp '$(BUILD_DIR)'/release/ricochet.exe '$(PREFIX)/$(TARGET)/bin/'
endef
