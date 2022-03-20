# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qt6-qtshadertools
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM      := 20881824cba0c1396c0fe6b27d0f995a261070b68fa3629b1a188147d58933cc
$(PKG)_TARGETS       := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := qt6-qtbase
$(PKG)_DEPS          := cc $($(PKG)_DEPS_$(BUILD)) $(BUILD)~$(PKG)

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/bin/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
