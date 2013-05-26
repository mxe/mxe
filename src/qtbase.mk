# This file is part of MXE.
# See index.html for further information.

PKG             := qtbase
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1220c88ad7f50bf1c08208e1eb05ee5d56635361
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://origin.releases.qt-project.org/qt5/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libodbc++ postgresql freetds openssl zlib libpng jpeg sqlite pcre fontconfig freetype dbus icu4c

define $(PKG)_UPDATE
    $(WGET) -q -O- http://origin.releases.qt-project.org/qt5/ | \
    $(SED) -n 's,.*href="\(5\.[0-9]\.[^/]*\)/".*,\1,p' | \
    grep -iv -- '-rc' | \
    tail -1
endef

define $(PKG)_BUILD
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
            -release \
            -static \
            -prefix '$(PREFIX)/$(TARGET)/qt5' \
            -icu \
            -opengl desktop \
            -no-glib \
            -accessibility \
            -nomake examples \
            -nomake tests \
            -qt-sql-sqlite \
            -qt-sql-odbc \
            -qt-sql-psql \
            -qt-sql-tds -D Q_USE_SYBASE \
            -system-zlib \
            -system-libpng \
            -system-libjpeg \
            -system-sqlite \
            -system-pcre \
            -openssl-linked \
            -dbus-linked \
            $(shell [ `uname` == 'Darwin' ] && echo -no-c++11) \
            -v

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    rm -rf '$(PREFIX)/$(TARGET)/qt5'
    $(MAKE) -C '$(1)' -j 1 install

    mkdir            '$(1)/test-qt'
    cd               '$(1)/test-qt' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' '$(PWD)/src/qt-test.pro'
    $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/test-qt/release/test-qt5.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
