# This file is part of MXE. See LICENSE.md for licensing information.

# MXE provides a fully featured build of Qt. Some users want more control...
# https://lists.nongnu.org/archive/html/mingw-cross-env-list/2013-08/msg00010.html
# https://lists.nongnu.org/archive/html/mingw-cross-env-list/2012-05/msg00019.html
#
# build of qt and deps is (say):  25 mins with 12.5 MB test program
# custom with minimal deps is:     4 mins with  7.6 MB test program
# custom min deps and cflags is:   4 mins with  5.9 MB test program
#
# make qt MXE_PLUGIN_DIRS='plugins/custom-qt-min'

$(info == Custom Qt overrides: $(lastword $(MAKEFILE_LIST)))

qt_DEPS := cc

define qt_BUILD
    $(SED) -i 's,\(^QMAKE_CFLAGS_RELEASE\).*,\1 = -pipe -Os -fomit-frame-pointer -momit-leaf-frame-pointer -fdata-sections -ffunction-sections,g' '$(1)/mkspecs/win32-g++/qmake.conf'
    cd '$(1)' && QTDIR='$(1)' ./bin/syncqt
    cd '$(1)' && \
        ./configure \
        -opensource \
        -confirm-license \
        -fast \
        -xplatform win32-g++-4.6 \
        -device-option CROSS_COMPILE=$(TARGET)- \
        -device-option PKG_CONFIG='$(TARGET)-pkg-config' \
        -force-pkg-config \
        -release \
        -static \
        -prefix '$(PREFIX)/$(TARGET)/qt' \
        -prefix-install \
        -make libs \
        -nomake demos \
        -nomake docs \
        -nomake examples \
        -nomake tools \
        -nomake translations \
        -no-accessibility \
        -no-audio-backend \
        -no-dbus \
        -no-declarative \
        -no-exceptions \
        -no-gif \
        -no-glib \
        -no-gstreamer \
        -no-iconv \
        -no-libjpeg \
        -no-libmng \
        -no-libpng \
        -no-libtiff \
        -no-multimedia \
        -no-opengl \
        -no-openssl \
        -no-phonon \
        -no-phonon-backend \
        -no-qt3support \
        -no-reduce-exports \
        -no-rpath \
        -no-script \
        -no-scripttools \
        -no-sql-mysql \
        -no-sql-odbc \
        -no-sql-psql \
        -no-sql-sqlite \
        -no-sql-tds \
        -no-stl \
        -no-svg \
        -no-webkit \
        -no-xmlpatterns \
        -qt-zlib \
        -v

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    rm -rf '$(PREFIX)/$(TARGET)/qt'
    $(MAKE) -C '$(1)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/qt/bin/qmake' '$(PREFIX)/bin/$(TARGET)'-qmake-qt4

    mkdir            '$(1)/test-qt'
    cd               '$(1)/test-qt' && '$(PREFIX)/$(TARGET)/qt/bin/qmake' '$(PWD)/src/$(PKG)-test.pro'
    $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/test-qt/release/test-qt.exe' '$(PREFIX)/$(TARGET)/bin/'

endef
