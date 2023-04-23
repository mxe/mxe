# This file is part of MXE. See LICENSE.md for licensing information.

include src/qt/qt6/qt6-conf.mk

PKG := qt6-qtimageformats
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := f9f810cd3ac7e60132c0da33f34fcfce42e3e764d6cad3020c2f3b1b42046f78
$(PKG)_DEPS     := cc qt6-conf qt6-qtbase jasper libmng libwebp tiff

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QT_CMAKE = '$(QT6_PREFIX)/$(if $(findstring mingw,$(TARGET)),bin,libexec)/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
    $(foreach fmt,ICNS Jp2 Mng Tga Tiff Wbmp Webp,\
      $(SED) -i 's|LINK_ONLY:Qt::|LINK_ONLY:Qt6::|g' '$(PREFIX)/$(TARGET)/qt6/lib/cmake/Qt6Gui/Qt6Q$(fmt)PluginTargets.cmake';)
endef
