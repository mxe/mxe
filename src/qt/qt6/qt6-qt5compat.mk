# This file is part of MXE. See LICENSE.md for licensing information.

PKG := qt6-qt5compat
$(eval $(QT6_METADATA))

# The following variables don't seem to be set correctly by the $(eval) above,
# presumably because this file is included before qtbase (qt5compat < qtbase).
qt6-qt5compat_SUBDIR    = $(subst qtbase,qt5compat,$(qt6-qtbase_SUBDIR))
qt6-qt5compat_FILE      = $(subst qtbase,qt5compat,$(qt6-qtbase_FILE))
qt6-qt5compat_URL       = $(subst qtbase,qt5compat,$(qt6-qtbase_URL))

$(PKG)_CHECKSUM := 1cf89198cf2cf8a5c15336ccd69fa1f39b779feb64117d6bbf5509c21c123f53
$(PKG)_DEPS     := cc qt6-qtbase

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/bin/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
endef
