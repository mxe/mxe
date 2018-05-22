# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ricochet
$(PKG)_WEBSITE  := https://ricochet.im/
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.4
$(PKG)_CHECKSUM := 4eb9000bc3f6c6a18659479015af980c16f971d468d10410ebeac8ada720d2cd
$(PKG)_GH_CONF  := ricochet-im/ricochet/tags, v
$(PKG)_DEPS     := cc openssl protobuf qtbase qtdeclarative qtmultimedia qtquickcontrols qttools

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
