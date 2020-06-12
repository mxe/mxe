# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtbase
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.15.0
$(PKG)_CHECKSUM := 9e7af10aece15fa9500369efde69cb220eee8ec3a6818afe01ce1e7d484824c5
$(PKG)_SUBDIR   := $(PKG)-everywhere-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.qt.io/official_releases/qt/5.15/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dbus fontconfig freetds freetype harfbuzz jpeg libmysqlclient libpng openssl pcre2 postgresql sqlite zlib zstd $(BUILD)~zstd
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(WGET) -q -O- https://download.qt.io/official_releases/qt/5.8/ | \
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
        SYBASE_LIBS="-lsybdb `'$(TARGET)-pkg-config' --libs-only-l openssl` -liconv -lws2_32" \
        PKG_CONFIG="${TARGET}-pkg-config" \
        PKG_CONFIG_SYSROOT_DIR="/" \
        PKG_CONFIG_LIBDIR="$(PREFIX)/$(TARGET)/lib/pkgconfig" \
        MAKE=$(MAKE) \
        ./configure \
            -opensource \
            -confirm-license \
            -xplatform win32-g++ \
            -device-option CROSS_COMPILE=${TARGET}- \
            -device-option PKG_CONFIG='${TARGET}-pkg-config' \
            -pkg-config \
            -force-pkg-config \
            -no-use-gold-linker \
            -release \
            $(if $(BUILD_STATIC), -static,)$(if $(BUILD_SHARED), -shared,) \
            -prefix '$(PREFIX)/$(TARGET)/qt5' \
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
    rm -rf '$(PREFIX)/$(TARGET)/qt5'
    $(MAKE) -C '$(1)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/qt5/bin/qmake' '$(PREFIX)/bin/$(TARGET)'-qmake-qt5

    mkdir            '$(1)/test-qt'
    cd               '$(1)/test-qt' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' '$(PWD)/src/qt-test.pro'
    $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/test-qt/$(BUILD_TYPE)/test-qt5.exe' '$(PREFIX)/$(TARGET)/bin/'

    # build test the manual way
    mkdir '$(1)/test-$(PKG)-pkgconfig'
    '$(PREFIX)/$(TARGET)/qt5/bin/uic' -o '$(1)/test-$(PKG)-pkgconfig/ui_qt-test.h' '$(TOP_DIR)/src/qt-test.ui'
    '$(PREFIX)/$(TARGET)/qt5/bin/moc' \
        -o '$(1)/test-$(PKG)-pkgconfig/moc_qt-test.cpp' \
        -I'$(1)/test-$(PKG)-pkgconfig' \
        '$(TOP_DIR)/src/qt-test.hpp'
    '$(PREFIX)/$(TARGET)/qt5/bin/rcc' -name qt-test -o '$(1)/test-$(PKG)-pkgconfig/qrc_qt-test.cpp' '$(TOP_DIR)/src/qt-test.qrc'
    '$(TARGET)-g++' \
        -W -Wall -std=c++0x -pedantic \
        '$(TOP_DIR)/src/qt-test.cpp' \
        '$(1)/test-$(PKG)-pkgconfig/moc_qt-test.cpp' \
        '$(1)/test-$(PKG)-pkgconfig/qrc_qt-test.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-pkgconfig.exe' \
        -I'$(1)/test-$(PKG)-pkgconfig' \
        `'$(TARGET)-pkg-config' Qt5Widgets$(BUILD_TYPE_SUFFIX) --cflags --libs`

    # setup cmake toolchain and test
    echo 'set(CMAKE_SYSTEM_PREFIX_PATH "$(PREFIX)/$(TARGET)/qt5" ${CMAKE_SYSTEM_PREFIX_PATH})' > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'
    $(CMAKE_TEST)

    # batch file to run test programs
    (printf 'set PATH=..\\lib;..\\qt5\\bin;..\\qt5\\lib;%%PATH%%\r\n'; \
     printf 'set QT_QPA_PLATFORM_PLUGIN_PATH=..\\qt5\\plugins\r\n'; \
     printf 'test-qt5.exe\r\n'; \
     printf 'test-qtbase-pkgconfig.exe\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/test-qt5.bat'
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        -prefix '$(PREFIX)/$(TARGET)/qt5' \
        -static \
        -release \
        -opensource \
        -confirm-license \
        -no-dbus \
        -no-{eventfd,glib,icu,openssl} \
        -no-sql-{db2,ibase,mysql,oci,odbc,psql,sqlite2,tds} \
        -no-use-gold-linker \
        -nomake examples \
        -nomake tests \
        -make tools \
        -continue \
        -verbose
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    rm -rf '$(PREFIX)/$(TARGET)/qt5'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/qt5/bin/qmake' '$(PREFIX)/bin/$(TARGET)'-qmake-qt5
endef
