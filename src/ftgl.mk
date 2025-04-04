# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ftgl
$(PKG)_WEBSITE  := https://sourceforge.net/projects/ftgl/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.3~rc5
$(PKG)_CHECKSUM := 521ff7bd62c459ff5372e269c223e2a6107a6a99a36afdc2ae634a973af70c59
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$(subst ~,-,$($(PKG)_VERSION)).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/FTGL Source/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc freeglut freetype

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/ftgl/files/FTGL Source/' | \
    $(SED) -n 's,.*<tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's/-lm/-lm -lstdc++/' '$(1)/ftgl.pc.in'
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-x \
        --disable-freetypetest \
        --with-ft-prefix='$(PREFIX)/$(TARGET)' \
        CXXFLAGS="-fpermissive"
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/src' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -m644 '$(1)/ftgl.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'

    # On case-insensitive filesystems, freetype2/ftglyph.h conflicts
    # with FTGL/FTGlyph.h. Call pkg-config separately as a workaround
    # to re-order include paths.

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' freetype2 --cflags --libs` \
        `'$(TARGET)-pkg-config' ftgl --cflags --libs`
endef
