# This file is part of MXE.
# See index.html for further information.

PKG             := qt
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f5880f11c139d7d8d01ecb8d874535f7d9553198
$(PKG)_SUBDIR   := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://releases.qt-project.org/qt4/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libodbc++ postgresql freetds openssl zlib libpng jpeg libmng tiff sqlite dbus

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://qt.gitorious.org/qt/qt/commits' | \
    grep '<li><a href="/qt/qt/commit/' | \
    $(SED) -n 's,.*<a[^>]*>v\([0-9][^<-]*\)<.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && QTDIR='$(1)' ./bin/syncqt
    cd '$(1)' && \
        OPENSSL_LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        PSQL_LIBS="-lpq -lsecur32 `'$(TARGET)-pkg-config' --libs-only-l openssl` -lws2_32" \
        SYBASE_LIBS="-lsybdb `'$(TARGET)-pkg-config' --libs-only-l gnutls` -liconv -lws2_32" \
        ./configure \
        -opensource \
        -confirm-license \
        -fast \
        -xplatform win32-g++-4.6 \
        -device-option CROSS_COMPILE=$(TARGET)- \
        -device-option PKG_CONFIG='$(TARGET)-pkg-config' \
        -force-pkg-config \
        -release \
        -exceptions \
        -static \
        -prefix '$(PREFIX)/$(TARGET)/qt' \
        -prefix-install \
        -script \
        -no-iconv \
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
        -qt-sql-sqlite \
        -qt-sql-odbc \
        -qt-sql-psql \
        -qt-sql-tds -D Q_USE_SYBASE \
        -system-zlib \
        -system-libpng \
        -system-libjpeg \
        -system-libtiff \
        -system-libmng \
        -system-sqlite \
        -openssl-linked \
        -dbus-linked \
        -v

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    rm -rf '$(PREFIX)/$(TARGET)/qt'
    $(MAKE) -C '$(1)' -j 1 install

    cd '$(1)/tools/assistant' && '$(1)/bin/qmake' assistant.pro
    $(MAKE) -C '$(1)/tools/assistant' -j '$(JOBS)' install

    cd '$(1)/tools/designer' && '$(1)/bin/qmake' designer.pro
    $(MAKE) -C '$(1)/tools/designer' -j '$(JOBS)' install

    # at least some of the qdbus tools are useful on target
    cd '$(1)/tools/qdbus' && '$(1)/bin/qmake' qdbus.pro
    $(MAKE) -C '$(1)/tools/qdbus' -j '$(JOBS)' install

    mkdir            '$(1)/test-qt'
    cd               '$(1)/test-qt' && '$(PREFIX)/$(TARGET)/qt/bin/qmake' '$(PWD)/$(2).pro'
    $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/test-qt/release/test-qt.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
