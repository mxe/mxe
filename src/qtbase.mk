# This file is part of MXE.
# See index.html for further information.

PKG             := qtbase
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3d553ed3fe4065b8453939831c007ec896ceb9ab
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://releases.qt-project.org/qt5/$($(PKG)_VERSION)/submodules_tar/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libodbc++ postgresql freetds openssl zlib libpng jpeg sqlite pcre fontconfig freetype

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qtbase.' >&2;
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
            -opengl desktop \
            -no-glib \
            -accessibility \
            -no-reduce-exports \
            -nomake demos \
            -nomake examples \
            -nomake docs \
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
