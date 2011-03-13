# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# ftgl
PKG             := ftgl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.3~rc5
$(PKG)_CHECKSUM := 8508f26c84001d7bc949246affa03744fa1fd22e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$(subst ~,-,$($(PKG)_VERSION)).tar.bz2
$(PKG)_WEBSITE  := http://sourceforge.net/projects/$(PKG)/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/FTGL Source/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/ftgl/files/FTGL Source/' | \
    $(SED) -n 's,.*<tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && aclocal -I m4
    cd '$(1)' && $(LIBTOOLIZE)
    cd '$(1)' && automake --gnu
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-x \
        --disable-freetypetest \
        --with-ft-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/src' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
