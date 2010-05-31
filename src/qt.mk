# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Qt
PKG             := qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.7.0-beta1
$(PKG)_CHECKSUM := ccb3126e64ce0a0142970a8898625fe5e84c7361
$(PKG)_SUBDIR   := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://qt.nokia.com/
$(PKG)_URL      := http://get.qt.nokia.com/qt/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libodbc++ postgresql freetds openssl libgcrypt zlib libpng jpeg libmng tiff giflib sqlite libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://qt.gitorious.org/qt/qt/commits' | \
    grep '<li><a href="/qt/qt/commit/' | \
    $(SED) -n 's,.*<a[^>]*>v\([0-9][^<-]*\)<.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # Adjust the makespec defs that contain the TARGET platform prefix.
    $(SED) -i 's,/usr/i686-pc-mingw32/,$(PREFIX)/$(TARGET)/,g' '$(1)/mkspecs/win32-g++-cross/qmake.conf'
    $(SED) -i 's,i686-pc-mingw32-,$(TARGET)-,g'                '$(1)/mkspecs/win32-g++-cross/qmake.conf'

    # Use the correct pg_config tool
    $(SED) -i 's,pg_config,$(TARGET)-pg_config,g;' '$(1)/configure'

    # We prefer static mingw-cross-env system libs for static build:
    # -system-zlib -system-libpng -system-libjpeg -system-libtiff -system-libmng -system-sqlite
    # There is no -system-gif option. NB -system-libmng will not link in shared build.
    # Linking QtNetwork4.dll requires OPENSSL_LIBS as does linking apps with static Qt.
    # Linking qsqlpsql4.dll plugin requires PSQL_LIBS as does linking apps with static Qt.
    # For shared Qt with qt-zlib, add -lQtCore4 to end of OPENSSL_LIBS to satisfy zlib dependency.
    # -no-largefile does not really disable large file support, it just prevents defining
    # QT_LARGEFILE_SUPPORT 64 which is not intended for win32.
    cd '$(1)' && \
        OPENSSL_LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        PSQL_LIBS="-lpq -lsecur32 `'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        ./configure \
        -opensource \
        -confirm-license \
        -fast \
        -xplatform win32-g++-cross \
        -force-pkg-config \
        -release \
        -exceptions \
        -static \
        -prefix '$(PREFIX)/$(TARGET)' \
        -prefix-install \
        -script \
        -opengl desktop \
        -no-webkit \
        -no-glib \
        -no-gstreamer \
        -no-phonon \
        -no-phonon-backend \
        -accessibility \
        -no-reduce-exports \
        -no-rpath \
        -make libs \
        -nomake demos \
        -nomake docs \
        -nomake examples \
        -plugin-sql-sqlite \
        -plugin-sql-odbc \
        -plugin-sql-psql \
        -plugin-sql-tds \
        -system-zlib \
        -system-libpng \
        -system-libjpeg \
        -system-libtiff \
        -system-libmng \
        -system-sqlite \
        -openssl-linked \
        -v

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    rm -rf '$(PREFIX)/$(TARGET)/mkspecs'
    $(MAKE) -C '$(1)' -j 1 install
    $(INSTALL) -m755 '$(1)/bin/moc'   '$(PREFIX)/bin/$(TARGET)-moc'
    $(INSTALL) -m755 '$(1)/bin/rcc'   '$(PREFIX)/bin/$(TARGET)-rcc'
    $(INSTALL) -m755 '$(1)/bin/uic'   '$(PREFIX)/bin/$(TARGET)-uic'
    $(INSTALL) -m755 '$(1)/bin/qmake' '$(PREFIX)/bin/$(TARGET)-qmake'

    mkdir            '$(1)/test-qt'
    cp '$(2)'*       '$(1)/test-qt/'
    cd               '$(1)/test-qt' && '$(TARGET)-qmake'
    $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/test-qt/release/test-qt.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
