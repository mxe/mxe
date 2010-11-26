# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# ftgl
PKG             := ftgl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.3-rc5
$(PKG)_CHECKSUM := 8508f26c84001d7bc949246affa03744fa1fd22e
$(PKG)_SUBDIR   := $(PKG)-$(subst -,~,$($(PKG)_VERSION))
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://sourceforge.net/projects/$(PKG)/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/FTGL Source/$(subst -,~,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/ftgl/files/FTGL Source/) | \
    $(SED) -n 's,.*ftgl-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --disable-freetypetest \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
