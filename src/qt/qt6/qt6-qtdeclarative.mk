# This file is part of MXE. See LICENSE.md for licensing information.

include src/qt/qt6/qt6-conf.mk

PKG := qt6-qtdeclarative
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM      := 5a0c39579a74d7cca581162c866ed0887287d4f8d5abff7ab9492d4a58fa9e2c
$(PKG)_TARGETS       := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := qt6-conf qt6-qtbase qt6-qtshadertools qt6-qtsvg
$(PKG)_DEPS          := cc $($(PKG)_DEPS_$(BUILD)) $(BUILD)~$(PKG) tiff

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/$(if $(findstring mingw,$(TARGET)),bin,libexec)/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    $(if $(BUILD_STATIC),'$(SED)' -i "/^ *LINK_LIBRARIES = /{s/$$/ `'$(TARGET)-pkg-config' --libs libbrotlidec libtiff-4`/g}" '$(BUILD_DIR)/build.ninja',)
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
