# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qca
$(PKG)_WEBSITE  := https://userbase.kde.org/QCA
$(PKG)_DESCR    := Qt Cryptographic Architecture
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := 4391a544521736986c7f7239168a2deced6a8b2445a8e114c6b47c49658e132d
$(PKG)_GH_CONF  := KDE/qca/tags,v
$(PKG)_DEPS     := cc openssl qtbase

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_TESTS=OFF \
        -DBUILD_TOOLS=OFF \
        -DUSE_RELATIVE_PATHS=OFF \
        -DBUILD_PLUGINS="auto" \
        -DINSTAL_PKGCONFIG=ON \
        -DQCA_MAN_INSTALL_DIR="$(BUILD_DIR)/null"
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # build test as qmake project
    mkdir '$(BUILD_DIR).test-qmake'
    cd '$(BUILD_DIR).test-qmake' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' \
        'greaterThan(QT_GCC_MAJOR_VERSION, 8): QMAKE_CXXFLAGS_WARN_ON += -Wno-deprecated-copy' \
        '$(PWD)/src/qca-test.pro'
    $(MAKE) -C '$(BUILD_DIR).test-qmake' -j 1
    $(INSTALL) -m755 '$(BUILD_DIR).test-qmake/$(BUILD_TYPE)/test-qca-qmake.exe' '$(PREFIX)/$(TARGET)/bin/'

    # build test as cmake project
    mkdir '$(BUILD_DIR).test-cmake'
    cd '$(BUILD_DIR).test-cmake' && $(TARGET)-cmake \
        -DPKG=$(PKG) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(BUILD_DIR).test-cmake' -j 1 install VERBOSE=ON

    # build test manually
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=gnu++11 -Wno-deprecated-copy \
        '$(PWD)/src/qca-test.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-pkgconfig.exe' \
        $(if $(BUILD_STATIC), -L'$(PREFIX)/$(TARGET)/qt5/plugins/crypto' -lqca-ossl) \
        `'$(TARGET)-pkg-config' qca2-qt5 --cflags --libs`
endef

$(PKG)_BUILD_STATIC =
