# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtbase
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.7.1
$(PKG)_CHECKSUM := edcdf549d94d98aff08e201dcb3ca25bc3628a37b1309e320d5f556b6b66557e
$(PKG)_PATCHES  := $(realpath $(sort $(wildcard $(dir $(lastword $(MAKEFILE_LIST)))/$(PKG)-[0-9]*.patch)))
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.qt.io/new_archive/qt/5.7/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dbus fontconfig freetds freetype harfbuzz jpeg libmysqlclient libpng openssl pcre postgresql sqlite zlib

# allows for side-by-side install with later Qt
# pkg-config and cmake will need tweaking to really get working
$(PKG)_VERSION_ID := qt5
QMAKE_EXECUTABLE   = $(TARGET)-qmake-$(qtbase_VERSION_ID)

define QMAKE_MAKE_INSTALL
    cd '$(BUILD_DIR)' && $(QMAKE_EXECUTABLE) '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef

define $(PKG)_UPDATE
    $(WGET) -q -O- https://download.qt-project.org/official_releases/qt/5.5/ | \
    $(SED) -n 's,.*href="\(5\.[0-9]\.[^/]*\)/".*,\1,p' | \
    grep -iv -- '-rc' | \
    sort |
    tail -1
endef

define $(PKG)_BUILD
    # ICU is buggy. See #653. TODO: reenable it some time in the future.
    cd '$(1)' && \
        OPENSSL_LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        PSQL_LIBS="-lpq -lsecur32 `'$(TARGET)-pkg-config' --libs-only-l openssl pthreads` -lws2_32" \
        SYBASE_LIBS="-lsybdb `'$(TARGET)-pkg-config' --libs-only-l gnutls` -liconv -lws2_32" \
        ./configure \
            -opensource \
            -c++std c++11 \
            -confirm-license \
            -xplatform win32-g++ \
            -device-option CROSS_COMPILE=${TARGET}- \
            -device-option PKG_CONFIG='${TARGET}-pkg-config' \
            -force-pkg-config \
            -no-use-gold-linker \
            -release \
            -static \
            -prefix '$(PREFIX)/$(TARGET)/$($(PKG)_VERSION_ID)' \
            -no-icu \
            -opengl desktop \
            -no-glib \
            -accessibility \
            -nomake examples \
            -nomake tests \
            -plugin-sql-mysql \
            -mysql_config $(PREFIX)/$(TARGET)/bin/mysql_config \
            -plugin-sql-sqlite \
            -plugin-sql-odbc \
            -plugin-sql-psql \
            -plugin-sql-tds -D Q_USE_SYBASE \
            -system-zlib \
            -system-libpng \
            -system-libjpeg \
            -system-sqlite \
            -fontconfig \
            -system-freetype \
            -system-harfbuzz \
            -system-pcre \
            -openssl-linked \
            -dbus-linked \
            -no-pch \
            -v \
            $($(PKG)_CONFIGURE_OPTS)

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    rm -rf '$(PREFIX)/$(TARGET)/$($(PKG)_VERSION_ID)'
    $(MAKE) -C '$(1)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/$($(PKG)_VERSION_ID)/bin/qmake' '$(PREFIX)/bin/$(TARGET)'-qmake-$($(PKG)_VERSION_ID)

    mkdir            '$(1)/test-qt'
    cd               '$(1)/test-qt' && '$(PREFIX)/$(TARGET)/$($(PKG)_VERSION_ID)/bin/qmake' '$(PWD)/src/qt-test.pro'
    $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)' $(BUILD_TYPE)
    $(INSTALL) -m755 '$(1)/test-qt/$(BUILD_TYPE)/test-qt5.exe' '$(PREFIX)/$(TARGET)/bin/test-$($(PKG)_VERSION_ID).exe'

    # build test the manual way
    mkdir '$(1)/test-$(PKG)-pkgconfig'
    '$(PREFIX)/$(TARGET)/$($(PKG)_VERSION_ID)/bin/uic' -o '$(1)/test-$(PKG)-pkgconfig/ui_qt-test.h' '$(TOP_DIR)/src/qt-test.ui'
    '$(PREFIX)/$(TARGET)/$($(PKG)_VERSION_ID)/bin/moc' \
        -o '$(1)/test-$(PKG)-pkgconfig/moc_qt-test.cpp' \
        -I'$(1)/test-$(PKG)-pkgconfig' \
        '$(TOP_DIR)/src/qt-test.hpp'
    '$(PREFIX)/$(TARGET)/$($(PKG)_VERSION_ID)/bin/rcc' -name qt-test -o '$(1)/test-$(PKG)-pkgconfig/qrc_qt-test.cpp' '$(TOP_DIR)/src/qt-test.qrc'
    '$(TARGET)-g++' \
        -W -Wall -std=c++0x -pedantic \
        '$(TOP_DIR)/src/qt-test.cpp' \
        '$(1)/test-$(PKG)-pkgconfig/moc_qt-test.cpp' \
        '$(1)/test-$(PKG)-pkgconfig/qrc_qt-test.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$($(PKG)_VERSION_ID)-pkgconfig.exe' \
        -I'$(1)/test-$(PKG)-pkgconfig' \
        `PKG_CONFIG_PATH_$(subst .,_,$(subst -,_,$(TARGET)))=$(PREFIX)/$(TARGET)/$($(PKG)_VERSION_ID)/lib/pkgconfig \
         '$(TARGET)-pkg-config' Qt5Widgets$(BUILD_TYPE_SUFFIX) --cflags --libs`

    # setup cmake toolchain
    echo 'set(CMAKE_SYSTEM_PREFIX_PATH "$(PREFIX)/$(TARGET)/$($(PKG)_VERSION_ID)" ${CMAKE_SYSTEM_PREFIX_PATH})' > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG)-$($(PKG)_VERSION_ID).cmake'

    # batch file to run test programs
    (printf 'set PATH=..\\lib;..\\$($(PKG)_VERSION_ID)\\bin;..\\$($(PKG)_VERSION_ID)\\lib;%%PATH%%\r\n'; \
     printf 'set QT_QPA_PLATFORM_PLUGIN_PATH=..\\$($(PKG)_VERSION_ID)\\plugins\r\n'; \
     printf 'test-$($(PKG)_VERSION_ID).exe\r\n'; \
     printf 'test-$($(PKG)_VERSION_ID)-pkgconfig.exe\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/test-$($(PKG)_VERSION_ID).bat'
endef


$(PKG)_BUILD_SHARED = $(subst -static ,-shared ,\
                      $($(PKG)_BUILD))
