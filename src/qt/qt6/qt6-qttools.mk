# This file is part of MXE. See LICENSE.md for licensing information.

include src/qt/qt6/qt6-conf.mk

PKG := qt6-qttools
$(eval $(QT6_METADATA))

$(PKG)_CHECKSUM := fa645589cc3f939022401a926825972a44277dead8ec8607d9f2662e6529c9a4
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := qt6-conf qt6-qtbase
$(PKG)_DEPS     := cc $($(PKG)_DEPS_$(BUILD)) qt6-qtdeclarative $(BUILD)~$(PKG)

define $(PKG)_BUILD
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DMySQL_INCLUDE_DIR='$(PREFIX)/$(TARGET)/include/mariadb' \
        -DMySQL_LIBRARY_DIR='$(PREFIX)/$(TARGET)/lib/mariadb' \
        -DMySQL_LIBRARY=$(if $(BUILD_STATIC),"`$(TARGET)-pkg-config --libs libmariadb`",'$(PREFIX)/$(TARGET)/lib/mariadb/libmariadb.a') \
        -DQT_BUILD_TOOLS_WHEN_CROSSCOMPILING=ON
    $(if $(BUILD_STATIC),'$(SED)' -i "/^ *LINK_LIBRARIES = /{s/$$/ `'$(TARGET)-pkg-config' --libs libbrotlidec`/g}" '$(BUILD_DIR)/build.ninja',)
    # not built for some reason. make dummy so install won't fail
    touch '$(BUILD_DIR)/bin/qhelpgenerator.exe'
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'

    # test QUiLoader
    $(QT6_QT_CMAKE) -S '$(PWD)/src/cmake/test' -B '$(BUILD_DIR).test-cmake' \
        -DQT_MAJOR=6 \
        -DPKG=qttools \
        -DPKG_VERSION=$($(PKG)_VERSION)
    # Make sure dependencies are in the right link order. -lsharpyuv must follow -lwebp.
    $(if $(BUILD_STATIC),'$(SED)' -i "/^ *LINK_LIBRARIES = /{s/$$/ `'$(TARGET)-pkg-config' --libs libwebp`/g}" '$(BUILD_DIR).test-cmake/build.ninja',)
    '$(TARGET)-cmake' --build '$(BUILD_DIR).test-cmake' -j '$(JOBS)'
    '$(TARGET)-cmake' --install '$(BUILD_DIR).test-cmake'
endef

define $(PKG)_BUILD_$(BUILD)
    $(QT6_QT_CMAKE) -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DFEATURE_linguist=ON \
        -DFEATURE_designer=OFF
    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'
endef
