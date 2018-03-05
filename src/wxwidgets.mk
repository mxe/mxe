# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wxwidgets
$(PKG)_WEBSITE  := https://www.wxwidgets.org/
$(PKG)_DESCR    := wxWidgets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.2
$(PKG)_CHECKSUM := 346879dc554f3ab8d6da2704f651ecb504a22e9d31c17ef5449b129ed711585d
$(PKG)_SUBDIR   := wxWidgets-$($(PKG)_VERSION)
$(PKG)_FILE     := wxWidgets-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/wxwindows/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat jpeg libiconv libpng sdl tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/wxwindows/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_CONFIGURE_OPTS
        $(MXE_CONFIGURE_OPTS) \
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
        LIBS=" `'$(TARGET)-pkg-config' --libs-only-l libtiff-4`" \
        CXXFLAGS='-std=gnu++11' \
        CXXCPP='$(TARGET)-g++ -E -std=gnu++11'
endef

define $(PKG)_BUILD
    # build the wxWidgets variant with unicode support
    mkdir '$(1).unicode'
    cd    '$(1).unicode' && '$(1)/configure' \
        $($(PKG)_CONFIGURE_OPTS) \
        --enable-unicode
    $(MAKE) -C '$(1).unicode' -j '$(JOBS)' \
        $(MXE_DISABLE_CRUFT)
    -$(MAKE) -C '$(1).unicode/locale' -j '$(JOBS)' allmo \
        $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(1).unicode' -j 1 install \
        $(if $(BUILD_SHARED),DLLDEST='/../bin') \
        $(MXE_DISABLE_CRUFT) __install_wxrc___depname=
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/wx-config' \
                     '$(PREFIX)/bin/$(TARGET)-wx-config'

    # build test program
    '$(TARGET)-g++' \
        -W -Wall -Werror -Wno-error=unused-local-typedefs -pedantic -std=gnu++0x \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-wxwidgets.exe' \
        `'$(TARGET)-wx-config' --cflags --libs`
endef

