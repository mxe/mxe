# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.7
$(PKG)_CHECKSUM := e2882295097e47fe089f8ac741a95fef47e0a73a3f3cdf21b56990638f626ea0
$(PKG)_SUBDIR   := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://download.qt.io/official_releases/qt/4.8/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dbus freetds jpeg libmng libpng openssl postgresql sqlite tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- https://download.qt.io/official_releases/qt/4.8/ | \
    $(SED) -n 's,.*href="\(4\.[0-9]\.[^/]*\)/".*,\1,p' | \
    grep -iv -- '-rc' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && QTDIR='$(1)' ./bin/syncqt
    cd '$(1)' && \
        OPENSSL_LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        PSQL_LIBS="-lpq -lsecur32 `'$(TARGET)-pkg-config' --libs-only-l openssl pthreads` -lws2_32" \
        SYBASE_LIBS="-lsybdb `'$(TARGET)-pkg-config' --libs-only-l gnutls` -liconv -lws2_32" \
        CXXFLAGS="-std=gnu++98" \
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
        -xmlpatterns \
        -qt-sql-sqlite \
        -qt-sql-odbc \
        -qt-sql-psql \
        -no-sql-mysql \
        -qt-sql-tds -D Q_USE_SYBASE \
        -system-zlib \
        -system-libpng \
        -system-libjpeg \
        -system-libtiff \
        -system-libmng \
        -system-sqlite \
        -openssl-linked \
        -dbus-linked \
        -no-pch \
        -v \
        $($(PKG)_CONFIGURE_OPTS)

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    rm -rf '$(PREFIX)/$(TARGET)/qt'
    $(MAKE) -C '$(1)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/qt/bin/qmake' '$(PREFIX)/bin/$(TARGET)'-qmake-qt4

    # symlink mkspecs/default if it isn't already
    # required on OSX to mimic linux installation
    [[ -L  '$(PREFIX)/$(TARGET)/qt/mkspecs/default' ]] || \
    rm -rf '$(PREFIX)/$(TARGET)/qt/mkspecs/default' && \
    ln -s  '$(PREFIX)/$(TARGET)/qt/mkspecs/win32-g++-4.6' \
           '$(PREFIX)/$(TARGET)/qt/mkspecs/default'

    # lrelease (from linguist) needed to prepare translation files
    $(MAKE) -C '$(1)/tools/linguist/lrelease' -j '$(JOBS)' install

    cd '$(1)/tools/assistant' && '$(1)/bin/qmake' assistant.pro
    # can't figure out where -lQtCLucene comes from so use
    # sed on the output instead of patching the input
    $(MAKE) -C '$(1)/tools/assistant' sub-lib-qmake_all
    $(SED) -i 's,-lQtCLucene$$,-lQtCLucene4,' '$(1)/tools/assistant/lib/Makefile.Release'
    $(MAKE) -C '$(1)/tools/assistant' -j '$(JOBS)' install

    # likewise for these two
    cd '$(1)/tools/designer/src/designer' && '$(1)/bin/qmake' designer.pro
    $(if $(BUILD_SHARED),\
        $(SED) -i 's/-lQtDesignerComponents /-lQtDesignerComponents4 /' '$(1)/tools/designer/src/designer/Makefile.Release' && \
        $(SED) -i 's/-lQtDesigner /-lQtDesigner4 /'                     '$(1)/tools/designer/src/designer/Makefile.Release',)
    cd '$(1)/tools/designer' && '$(1)/bin/qmake' designer.pro
    $(MAKE) -C '$(1)/tools/designer' -j '$(JOBS)' install

    # at least some of the qdbus tools are useful on target
    cd '$(1)/tools/qdbus' && '$(1)/bin/qmake' qdbus.pro
    $(MAKE) -C '$(1)/tools/qdbus' -j '$(JOBS)' install

    mkdir            '$(1)/test-qt'
    cd               '$(1)/test-qt' && '$(PREFIX)/$(TARGET)/qt/bin/qmake' '$(PWD)/src/$(PKG)-test.pro'
    $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/test-qt/release/test-qt.exe' '$(PREFIX)/$(TARGET)/bin/'

    # copy pkg-config files to standard directory
    cp '$(PREFIX)/$(TARGET)'/qt/lib/pkgconfig/* '$(PREFIX)/$(TARGET)'/lib/pkgconfig/

    # build test the manual way
    mkdir '$(1)/test-$(PKG)-pkgconfig'
    '$(PREFIX)/$(TARGET)/qt/bin/uic' -o '$(1)/test-$(PKG)-pkgconfig/ui_qt-test.h' '$(TOP_DIR)/src/qt-test.ui'
    '$(PREFIX)/$(TARGET)/qt/bin/moc' \
        -o '$(1)/test-$(PKG)-pkgconfig/moc_qt-test.cpp' \
        -I'$(1)/test-$(PKG)-pkgconfig' \
        '$(TOP_DIR)/src/qt-test.hpp'
    '$(PREFIX)/$(TARGET)/qt/bin/rcc' -name qt-test -o '$(1)/test-$(PKG)-pkgconfig/qrc_qt-test.cpp' '$(TOP_DIR)/src/qt-test.qrc'
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++0x -pedantic \
        '$(TOP_DIR)/src/qt-test.cpp' \
        '$(1)/test-$(PKG)-pkgconfig/moc_qt-test.cpp' \
        '$(1)/test-$(PKG)-pkgconfig/qrc_qt-test.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-pkgconfig.exe' \
        -I'$(1)/test-$(PKG)-pkgconfig' \
        `'$(TARGET)-pkg-config' QtGui --cflags --libs`

    # setup cmake toolchain
    echo 'set(QT_QMAKE_EXECUTABLE $(PREFIX)/$(TARGET)/qt/bin/qmake CACHE FILEPATH "Qt4 qmake executable")' > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'
    # fix static linking errors of QtGui to missing lcms2 and lzma
    # introduced by poor libmng linking
    echo 'set(MNG_LIBRARY mng lcms2 lzma)' >> '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'

    # test cmake
    mkdir '$(1).test-cmake'
    cd '$(1).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        -DPKG_VERSION=$($(PKG)_VERSION) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(1).test-cmake' -j 1 install
endef

$(PKG)_BUILD_SHARED = $(subst -static ,-shared ,\
                      $(subst -no-webkit ,-webkit ,\
                      $(subst -qt-sql-,-plugin-sql-,\
                      $($(PKG)_BUILD))))
