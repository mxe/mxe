# Copyright (C) 2009  Mark Brand
#                     Volker Grabsch
#                     Tony Theodore
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Qt
PKG             := qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.6.0-beta1
$(PKG)_CHECKSUM := ab3898f0d7307decbce03a6fc6829218bba17311
$(PKG)_SUBDIR   := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://qt.nokia.com/
$(PKG)_URL      := http://get.qt.nokia.com/qt/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libodbc++

define $(PKG)_UPDATE
    wget -q -O- 'http://qt.gitorious.org/qt/qt/commits' | \
    grep '<li><a href="/qt/qt/commit/' | \
    $(SED) -n 's,.*<a[^>]*>v\([0-9][^>]*\)<.*,\1,p' | \
    grep -v tp | \
    tail -1
endef

define $(PKG)_BUILD

    # Native, unpatched build of Qt for moc, rcc, uic and qmake
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,qt)
    mv '$(1)/$(qt_SUBDIR)' '$(1).native'

    # But, 4.6.0-beta1 native build needs this bugfix too
    cp '$(1)'/src/3rdparty/javascriptcore/JavaScriptCore/JavaScriptCore.pro \
       '$(1).native'/src/3rdparty/javascriptcore/JavaScriptCore/JavaScriptCore.pro

    $(SED) 's,PLATFORM_X11=yes,PLATFORM_X11=no,'           -i '$(1)'.native/configure
    $(SED) 's,PLATFORM=solaris-cc$$,PLATFORM=solaris-g++,' -i '$(1)'.native/configure
    cd '$(1)'.native && ./configure \
        -opensource \
        -confirm-license \
        -prefix '$(PREFIX)/$(TARGET)' \
        -prefix-install \
        -fast \
        -release \
        -no-exceptions \
        -nomake demos \
        -nomake examples \
        -nomake libs \
        -nomake tools \
        -nomake docs \
        -nomake translations

    $(MAKE) -C '$(1)'.native -j $(JOBS) sub-tools-bootstrap
    $(MAKE) -C '$(1)'.native -j $(JOBS) sub-moc
    $(MAKE) -C '$(1)'.native -j $(JOBS) sub-rcc
    $(MAKE) -C '$(1)'.native -j $(JOBS) sub-uic

    # rebuild qmake to use "-unix" as default and to use the correct "ar" command
    $(SED) 's,\(Option::TARG_MODE Option::target_mode = Option::TARG_\)[A-Z_]*,\1UNIX_MODE,' -i '$(1)'.native/qmake/option.cpp
    $(SED) 's,"ar -M,"$(TARGET)-ar -M,' -i '$(1)'.native/qmake/generators/win32/mingw_make.cpp
    $(MAKE) -C '$(1)'.native/qmake -j $(JOBS)

    # install the native tools manually
    $(INSTALL) -m755 '$(1)'.native/bin/moc   '$(PREFIX)/bin/$(TARGET)-moc'
    $(INSTALL) -m755 '$(1)'.native/bin/rcc   '$(PREFIX)/bin/$(TARGET)-rcc'
    $(INSTALL) -m755 '$(1)'.native/bin/uic   '$(PREFIX)/bin/$(TARGET)-uic'
    $(INSTALL) -m755 '$(1)'.native/bin/qmake '$(PREFIX)/bin/$(TARGET)-qmake'

    # Trick the build system into using native tools
    ln -s '$(1)'.native/bin/{moc,rcc,uic,qmake} '$(1)'/bin/

    # Make sure we don't build the tools again
    echo 'qmake:' >'$(1)'/qmake/Makefile.unix
    for f in `ls -1 '$(1)'/src/tools`; \
        do echo TEMPLATE = subdirs >'$(1)'/src/tools/"$$f"/"$$f".pro; \
    done

    # Trick the buildsystem into using win32 feature files:
    mv '$(1)'/mkspecs/features/unix '$(1)'/mkspecs/features/unix.orig
    ln -s win32 '$(1)'/mkspecs/features/unix

    # Adjust the mkspec values that contain the TARGET platform prefix.
    # The patch planted strings HOSTPLATFORMPREFIX and HOSTPLATFORMINCLUDE.
    $(SED) 's,HOSTPLATFORMPREFIX-,$(TARGET)-,g'                  -i '$(1)'/mkspecs/win32-g++/qmake.conf
    $(SED) 's,HOSTPLATFORMINCLUDE,$(PREFIX)/$(TARGET)/include,g' -i '$(1)'/mkspecs/win32-g++/qmake.conf

    # Make sure qmake doesn't use compilation paths meant for unix
    find '$(1)'/src -name '*.pr[oi]' -exec \
        $(SED) 's,\(^\|[^_/]\)unix,\1linux,g' -i {} \;

    # Make qmake use compilation paths meant for Windows
    find '$(1)'/src -name '*.pr[oi]' -exec \
        $(SED) 's,\(^\|[^_/]\)win32\([^-]\|$$\),\1unix\2,g' -i {} \;

    # Configure Qt for MinGW target
    cd '$(1)' && ./configure \
        -opensource \
        -confirm-license \
        -xplatform win32-g++ \
        -host-arch i386 \
        -host-little-endian \
        -little-endian \
        -release \
        -exceptions \
        -static \
        -prefix '$(PREFIX)/$(TARGET)' \
        -prefix-install \
        -bindir '$(1)'/bindirsink \
        -script \
        -opengl desktop \
        -no-webkit \
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
        -qt-zlib \
        -qt-gif \
        -qt-libtiff \
        -qt-libpng \
        -qt-libmng \
        -qt-libjpeg \
        -v

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(TARGET)-ranlib '$(1)'/lib/*.a
    rm -rf '$(PREFIX)/$(TARGET)/mkspecs'
    $(MAKE) -C '$(1)' install
endef
