# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qt6-qttranslations
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := bbe0291502c2604b72fef730e1935bd22f8b921d8c473250f298a723b2a9c496
$(PKG)_DEPS     := cc qt6-qtbase qt6-qttools

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/bin/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DQT_HOST_PATH='$(PREFIX)/$(BUILD)/$(MXE_QT6_ID)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
