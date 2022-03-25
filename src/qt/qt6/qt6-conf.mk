# This file is part of MXE. See LICENSE.md for licensing information.

include src/qt/qt6/qt6-qtbase.mk

PKG            := qt6-conf
$(PKG)_VERSION  = $(qt6-qtbase_VERSION)
$(PKG)_DEPS    := qt6-qtbase
$(PKG)_TARGETS := $(BUILD) $(MXE_TARGETS)

# ensure conf is also built for a minimal `make qt6-qtbase`
qt6-qtbase: qt6-conf

QT6_PREFIX   = '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
QT6_QMAKE    = '$(TARGET)-$(MXE_QT6_ID)-qmake'
QT6_QT_CMAKE = '$(QT6_PREFIX)/bin/qt-cmake-private' \
                   -DCMAKE_INSTALL_PREFIX='$(QT6_PREFIX)'

define QT6_METADATA
    $(PKG)_WEBSITE  := https://www.qt.io/
    $(PKG)_DESCR    := Qt
    $(PKG)_IGNORE   :=
    $(PKG)_VERSION   = $(qt6-qtbase_VERSION)
    $(PKG)_SUBDIR    = $(subst qtbase,$(subst qt6-,,$(PKG)),$(qt6-qtbase_SUBDIR))
    $(PKG)_FILE      = $(subst qtbase,$(subst qt6-,,$(PKG)),$(qt6-qtbase_FILE))
    $(PKG)_URL       = $(subst qtbase,$(subst qt6-,,$(PKG)),$(qt6-qtbase_URL))
    $(PKG)_UPDATE    = echo $(qt6-qtbase_VERSION)
endef

define $(PKG)_BUILD
    # qmake is a script that calls native qmake with a conf file in its current dir
    (echo '#!/bin/sh'; \
     echo 'exec "$(QT6_PREFIX)/bin/qmake" "$$@"') \
             > '$(PREFIX)/bin/$(TARGET)-$(MXE_QT6_ID)-qmake'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-$(MXE_QT6_ID)-qmake'

    # test qmake
    mkdir '$(BUILD_DIR).test-qmake'
    cd '$(BUILD_DIR).test-qmake' && \
        $(QT6_QMAKE) \
        -after TARGET=test-$(MXE_QT6_ID)-qmake \
        '$(PWD)/src/qt-test.pro'
    $(MAKE) -C '$(BUILD_DIR).test-qmake' '$(BUILD_TYPE)' -j '$(JOBS)'
    $(INSTALL) -m755 '$(BUILD_DIR).test-qmake/$(BUILD_TYPE)/test-$(MXE_QT6_ID)-qmake.exe' '$(PREFIX)/$(TARGET)/bin/'

    # test cmake
    $(QT6_QT_CMAKE) -S '$(PWD)/src/cmake/test' -B '$(BUILD_DIR).test-cmake' \
        -DQT_MAJOR=6 \
        -DPKG=qtbase \
        -DPKG_VERSION=$($(PKG)_VERSION)
    $(TARGET)-cmake --build '$(BUILD_DIR).test-cmake' -j '$(JOBS)'
    $(TARGET)-cmake --install '$(BUILD_DIR).test-cmake'

    # build test the manual way
# TODO pkg-config files aren't installed
#     mkdir '$(BUILD_DIR).test-pkgconfig'
#     '$(QT6_PREFIX)/bin/uic' -o '$(BUILD_DIR).test-pkgconfig/ui_qt-test.h' '$(TOP_DIR)/src/qt-test.ui'
#     '$(QT6_PREFIX)/bin/moc' \
#         -o '$(BUILD_DIR).test-pkgconfig/moc_qt-test.cpp' \
#         -I'$(BUILD_DIR).test-pkgconfig' \
#         '$(TOP_DIR)/src/qt-test.hpp'
#     '$(PREFIX)/$(TARGET)/qt5/bin/rcc' -name qt-test -o '$(BUILD_DIR).test-pkgconfig/qrc_qt-test.cpp' '$(TOP_DIR)/src/qt-test.qrc'
#     '$(TARGET)-g++' \
#         -W -Wall -std=c++0x -pedantic \
#         '$(TOP_DIR)/src/qt-test.cpp' \
#         '$(BUILD_DIR).test-pkgconfig/moc_qt-test.cpp' \
#         '$(BUILD_DIR).test-pkgconfig/qrc_qt-test.cpp' \
#         -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-pkgconfig.exe' \
#         -I'$(BUILD_DIR).test-pkgconfig' \
#         `'$(TARGET)-pkg-config' Qt6Widgets$(BUILD_TYPE_SUFFIX) --cflags --libs`

    # batch file to run test programs
    (printf 'set PATH=..\\lib;..\\$(MXE_QT6_ID)\\bin;..\\$(MXE_QT6_ID)\\lib;%%PATH%%\r\n'; \
     printf 'set QT_QPA_PLATFORM_PLUGIN_PATH=..\\$(MXE_QT6_ID)\\plugins\r\n'; \
     printf 'test-$(MXE_QT6_ID)-qmake.exe\r\n'; \
     printf 'test-$(MXE_QT6_ID)-cmake.exe\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/test-$(MXE_QT6_ID).bat'
endef

define $(PKG)_BUILD_$(BUILD)

endef
