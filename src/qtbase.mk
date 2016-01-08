# This file is part of MXE.
# See index.html for further information.

PKG             := qtbase
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.5.1
$(PKG)_CHECKSUM := dfa4e8a4d7e4c6b69285e7e8833eeecd819987e1bdbe5baa6b6facd4420de916
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://download.qt.io/official_releases/qt/5.5/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc dbus fontconfig freetds freetype harfbuzz jpeg libpng libmysqlclient openssl pcre postgresql sqlite zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- http://download.qt-project.org/official_releases/qt/5.5/ | \
    $(SED) -n 's,.*href="\(5\.[0-9]\.[^/]*\)/".*,\1,p' | \
    grep -iv -- '-rc' | \
    sort |
    tail -1
endef

define $(PKG)_BUILD
    # ICU is buggy. See #653. TODO: reenable it some time in the future.
    cd '$(1)' && \
        OPENSSL_LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        PSQL_LIBS="-lpq -lsecur32 `'$(TARGET)-pkg-config' --libs-only-l openssl` -lws2_32" \
        SYBASE_LIBS="-lsybdb `'$(TARGET)-pkg-config' --libs-only-l gnutls` -liconv -lws2_32" \
        ./configure \
            -opensource \
            -confirm-license \
            -xplatform win32-g++ \
            -device-option CROSS_COMPILE=${TARGET}- \
            -device-option PKG_CONFIG='${TARGET}-pkg-config' \
            -force-pkg-config \
            -no-use-gold-linker \
            -release \
            -static \
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
            -v

    # invoke qmake with removed debug options as a workaround for
    # https://bugreports.qt-project.org/browse/QTBUG-30898
    $(MAKE) -C '$(1)' -j '$(JOBS)' QMAKE="$(1)/bin/qmake CONFIG-='debug debug_and_release'"
    rm -rf '$(PREFIX)/$(TARGET)/qt5'
    $(MAKE) -C '$(1)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/qt5/bin/qmake' '$(PREFIX)/bin/$(TARGET)'-qmake-qt5

    mkdir            '$(1)/test-qt'
    cd               '$(1)/test-qt' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' '$(PWD)/src/qt-test.pro'
    $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/test-qt/release/test-qt5.exe' '$(PREFIX)/$(TARGET)/bin/'

    # build test the manual way
    mkdir '$(1)/test-$(PKG)-pkgconfig'
    '$(PREFIX)/$(TARGET)/qt5/bin/uic' -o '$(1)/test-$(PKG)-pkgconfig/ui_qt-test.h' '$(TOP_DIR)/src/qt-test.ui'
    '$(PREFIX)/$(TARGET)/qt5/bin/moc' \
        -o '$(1)/test-$(PKG)-pkgconfig/moc_qt-test.cpp' \
        -I'$(1)/test-$(PKG)-pkgconfig' \
        '$(TOP_DIR)/src/qt-test.hpp'
    '$(PREFIX)/$(TARGET)/qt5/bin/rcc' -name qt-test -o '$(1)/test-$(PKG)-pkgconfig/qrc_qt-test.cpp' '$(TOP_DIR)/src/qt-test.qrc'
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++0x -pedantic \
        '$(TOP_DIR)/src/qt-test.cpp' \
        '$(1)/test-$(PKG)-pkgconfig/moc_qt-test.cpp' \
        '$(1)/test-$(PKG)-pkgconfig/qrc_qt-test.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-pkgconfig.exe' \
        -I'$(1)/test-$(PKG)-pkgconfig' \
        `'$(TARGET)-pkg-config' Qt5Widgets --cflags --libs`

    # setup cmake toolchain
    echo 'set(CMAKE_SYSTEM_PREFIX_PATH "$(PREFIX)/$(TARGET)/qt5" ${CMAKE_SYSTEM_PREFIX_PATH})' > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'

    # batch file to run test programs
    (printf 'set PATH=..\\lib;..\\qt5\\bin;..\\qt5\\lib;%%PATH%%\r\n'; \
     printf 'set QT_QPA_PLATFORM_PLUGIN_PATH=..\\qt5\\plugins\r\n'; \
     printf 'test-qt5.exe\r\n'; \
     printf 'test-qtbase-pkgconfig.exe\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/test-qt5.bat'
endef


$(PKG)_BUILD_SHARED = $(subst -static ,-shared ,\
                      $($(PKG)_BUILD))
