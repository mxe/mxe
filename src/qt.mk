# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Qt
PKG             := qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.6.2
$(PKG)_CHECKSUM := 977c10b88a2230e96868edc78a9e3789c0fcbf70
$(PKG)_SUBDIR   := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://qt.nokia.com/
$(PKG)_URL      := http://get.qt.nokia.com/qt/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libodbc++ postgresql freetds openssl libgcrypt zlib libpng jpeg libmng tiff sqlite

define $(PKG)_UPDATE
    wget -q -O- 'http://qt.gitorious.org/qt/qt/commits' | \
    grep '<li><a href="/qt/qt/commit/' | \
    $(SED) -n 's,.*<a[^>]*>v\([0-9][^>-]*\)<.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD

    # Native, unpatched build of Qt for moc, rcc, uic and qmake
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,qt)
    mv '$(1)/$(qt_SUBDIR)' '$(1).native'

    $(SED) -i 's,PLATFORM_X11=yes,PLATFORM_X11=no,'           '$(1)'.native/configure
    $(SED) -i 's,PLATFORM=solaris-cc$$,PLATFORM=solaris-g++,' '$(1)'.native/configure
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

    $(MAKE) -C '$(1)'.native -j '$(JOBS)' sub-tools-bootstrap
    $(MAKE) -C '$(1)'.native -j '$(JOBS)' sub-moc
    $(MAKE) -C '$(1)'.native -j '$(JOBS)' sub-rcc
    $(MAKE) -C '$(1)'.native -j '$(JOBS)' sub-uic

    # rebuild qmake to use "-unix" as default and to use the correct "ar" command
    $(SED) -i 's,\(Option::TARG_MODE Option::target_mode = Option::TARG_\)[A-Z_]*,\1UNIX_MODE,' '$(1)'.native/qmake/option.cpp
    $(SED) -i 's,"ar -M,"$(TARGET)-ar -M,' '$(1)'.native/qmake/generators/win32/mingw_make.cpp
    $(MAKE) -C '$(1)'.native/qmake -j '$(JOBS)'

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
    $(SED) -i 's,HOSTPLATFORMPREFIX-,$(TARGET)-,g'                  '$(1)'/mkspecs/win32-g++/qmake.conf
    $(SED) -i 's,HOSTPLATFORMINCLUDE,$(PREFIX)/$(TARGET)/include,g' '$(1)'/mkspecs/win32-g++/qmake.conf

    # Make sure qmake doesn't use compilation paths meant for unix
    find '$(1)'/src -name '*.pr[oi]' -exec \
        $(SED) -i 's,\(^\|[^_/]\)unix,\1linux,g' {} \;

    # Make qmake use compilation paths meant for MinGW or Windows in general
    find '$(1)'/src -name '*.pr[oi]' -exec \
        $(SED) -i 's,\(^\|[^_/]\)win32-g++\([^-]\|$$\),\1unix\2,g' {} \;
    find '$(1)'/src -name '*.pr[oi]' -exec \
        $(SED) -i 's,\(^\|[^_/]\)win32\([^-]\|$$\),\1unix\2,g' {} \;

    # Use the correct pg_config tool
    $(SED) -i 's,pg_config,$(TARGET)-pg_config,g;' '$(1)'/configure

    # Configure Qt for MinGW target
    # We prefer static mingw-cross-env system libs for static build:
    # -system-zlib -system-libpng -system-libjpeg -system-libtiff -system-libmng -system-sqlite
    # There is no -system-gif option. NB -system-libmng will not link in shared build.
    # Linking PSQL shared plugin requires PSQL_LIBS. Harmless for static build.
    cd '$(1)' && \
        OPENSSL_LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
        PSQL_LIBS="-lpq -lsecur32 `'$(TARGET)-pkg-config' --libs-only-l openssl`" ./configure \
        -opensource \
        -confirm-license \
        -xplatform win32-g++ \
        -host-arch i386 \
        -host-little-endian \
        -little-endian \
        -largefile \
        -force-pkg-config \
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
        -plugin-sql-psql \
        -plugin-sql-tds \
        -system-zlib \
        -system-libpng \
        -system-libjpeg \
        -system-libtiff \
        -system-libmng \
        -system-sqlite \
        -qt-gif \
        -openssl-linked \
        -no-fontconfig \
        -v

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    '$(TARGET)-ranlib' '$(1)'/lib/*.a
    rm -rf '$(PREFIX)/$(TARGET)/mkspecs'
    $(MAKE) -C '$(1)' -j 1 install

    mkdir            '$(1)/test-qt'
    cp '$(2)'*       '$(1)/test-qt/'
    cd               '$(1)/test-qt' && '$(TARGET)-qmake'
    $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/test-qt/release/test-qt.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
