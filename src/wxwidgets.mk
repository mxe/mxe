# This file is part of MXE.
# See index.html for further information.

PKG             := wxwidgets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.0
$(PKG)_CHECKSUM := 756a9c54d1f411e262f03bacb78ccef085a9880a
$(PKG)_SUBDIR   := wxWidgets-$($(PKG)_VERSION)
$(PKG)_FILE     := wxWidgets-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/wxwindows/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv libpng jpeg tiff sdl zlib expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/wxwindows/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_CONFIGURE_OPTS
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-gui \
        --disable-stl \
        --enable-threads \
        --disable-universal \
        --with-themes=all \
        --with-msw \
        --with-opengl \
        --with-libpng=sys \
        --with-libjpeg=sys \
        --with-libtiff=sys \
        --with-regex=yes \
        --with-zlib=sys \
        --with-expat=sys \
        --with-sdl \
        --without-gtk \
        --without-motif \
        --without-mac \
        --without-macosx-sdk \
        --without-cocoa \
        --without-wine \
        --without-pm \
        --without-microwin \
        --without-libxpm \
        --without-libmspack \
        --without-gnomeprint \
        --without-gnomevfs \
        --without-hildon \
        --without-dmalloc \
        --without-odbc \
        LIBS=" `'$(TARGET)-pkg-config' --libs-only-l libtiff-4`"
endef

define $(PKG)_BUILD_UNICODE
    # build the wxWidgets variant with unicode support
    mkdir '$(1).unicode'
    cd    '$(1).unicode' && '$(1)/configure' \
        $($(PKG)_CONFIGURE_OPTS) \
        --enable-unicode
    $(MAKE) -C '$(1).unicode' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    -$(MAKE) -C '$(1).unicode/locale' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= allmo
    $(MAKE) -C '$(1).unicode' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= __install_wxrc___depname=
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/bin/$(TARGET)-wx-config'
endef

# ansi build has been long deprecated
# so don't build it by default
define $(PKG)_BUILD_ANSI
    # build the wxWidgets variant without unicode support
    mkdir '$(1).ansi'
    cd    '$(1).ansi' && '$(1)/configure' \
        $($(PKG)_CONFIGURE_OPTS) \
        --disable-unicode
    $(MAKE) -C '$(1).ansi' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    # backup of the unicode wx-config script
    # such that "make install" won't overwrite it
    mv '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/$(TARGET)/bin/wx-config-backup'

    $(MAKE) -C '$(1).ansi' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= __install_wxrc___depname=
    mv '$(PREFIX)/$(TARGET)/bin/wx-config' '$(PREFIX)/$(TARGET)/bin/wx-config-nounicode'
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/wx-config-nounicode' '$(PREFIX)/bin/$(TARGET)-wx-config-nounicode'

    # restore the unicode wx-config script
    mv '$(PREFIX)/$(TARGET)/bin/wx-config-backup' '$(PREFIX)/$(TARGET)/bin/wx-config'
endef

define $(PKG)_TEST
    # build test program
    '$(TARGET)-g++' \
        -W -Wall -Werror -Wno-error=unused-local-typedefs -pedantic -std=gnu++0x \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-wxwidgets.exe' \
        `'$(TARGET)-wx-config' --cflags --libs`
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_UNICODE)
    $($(PKG)_TEST)
endef

$(PKG)_BUILD_SHARED =
