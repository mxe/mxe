# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qt6-qtdeclarative
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM      := fa6a8b5bfe43203daf022b7949c7874240ec28b9c4b7ebc52b2e5ea440e6e94f
$(PKG)_TARGETS       := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := qt6-qtbase qt6-qtshadertools
$(PKG)_DEPS          := cc $($(PKG)_DEPS_$(BUILD)) $(BUILD)~$(PKG)

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/bin/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    $(if $(BUILD_STATIC),'$(SED)' -i "/^ *LINK_LIBRARIES = /{s/$$/ `'$(TARGET)-pkg-config' --libs libtiff-4`/g}" '$(BUILD_DIR)/build.ninja',)
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
