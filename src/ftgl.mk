# This file is part of MXE.
# See index.html for further information.

PKG             := ftgl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.3~rc5
$(PKG)_CHECKSUM := 8508f26c84001d7bc949246affa03744fa1fd22e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$(subst ~,-,$($(PKG)_VERSION)).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/FTGL Source/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freeglut freetype

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/ftgl/files/FTGL Source/' | \
    $(SED) -n 's,.*<tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(SED) -i 's/-lm/-lm -lstdc++/' ftgl.pc.in
    cd '$(1)' && aclocal -I m4
    cd '$(1)' && $(LIBTOOLIZE)
    cd '$(1)' && automake --gnu
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-x \
        --disable-freetypetest \
        --with-ft-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/src' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -m644 '$(1)/ftgl.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' ftgl --cflags --libs`
endef
