# This file is part of MXE.
# See index.html for further information.

PKG             := qt
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a074d0f605f009e23c63e0a4cb9b71c978146ffc
$(PKG)_SUBDIR   := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://get.qt.nokia.com/qt/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libodbc++ postgresql freetds openssl zlib libpng jpeg libmng tiff sqlite dbus

define $(PKG)_UPDATE
    wget -q -O- 'http://qt.gitorious.org/qt/qt/commits' | \
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
        -xplatform unsupported/win32-g++-4.6-cross \
        -force-pkg-config \
        -release \
        -exceptions \
        -static \
        -prefix '$(PREFIX)/$(TARGET)' \
        -prefix-install \
        -script \
        -no-iconv \
        -opengl desktop \
        -webkit \
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
    rm -rf '$(PREFIX)/$(TARGET)/mkspecs'
    $(MAKE) -C '$(1)' -j 1 install
    $(INSTALL) -m755 '$(1)/bin/moc'   '$(PREFIX)/bin/$(TARGET)-moc'
    $(INSTALL) -m755 '$(1)/bin/rcc'   '$(PREFIX)/bin/$(TARGET)-rcc'
    $(INSTALL) -m755 '$(1)/bin/uic'   '$(PREFIX)/bin/$(TARGET)-uic'
    $(INSTALL) -m755 '$(1)/bin/qmake' '$(PREFIX)/bin/$(TARGET)-qmake'

    # at least some of the qdbus tools are useful on target
    cd '$(1)/tools/qdbus' && '$(1)/bin/qmake' qdbus.pro
    $(MAKE) -C '$(1)/tools/qdbus' -j '$(JOBS)' install

    mkdir            '$(1)/test-qt'
    cd               '$(1)/test-qt' && '$(TARGET)-qmake' '$(PWD)/$(2).pro'
    $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/test-qt/release/test-qt.exe' '$(PREFIX)/$(TARGET)/bin/'

    # In case a MXE tree is relocated, this script can be used
    # to write an appropriate qt.conf file that will override the built-in
    # prefix, etc. in qmake.
    wget --no-check-certificate -O- \
      https://raw.github.com/gist/2501032/update-qtconf.sh \
      > '$(PREFIX)/bin/update-qtconf.sh'
    chmod +x '$(PREFIX)/bin/update-qtconf.sh'
endef
