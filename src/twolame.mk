# This file is part of MXE.
# See index.html for further information.

PKG             := twolame
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.13
$(PKG)_CHECKSUM := 98f332f48951f47f23f70fd0379463aff7d7fb26f07e1e24e42ddef22cc6112a
$(PKG)_SUBDIR   := twolame-$($(PKG)_VERSION)
$(PKG)_FILE     := twolame-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/$(PKG)/files/$(PKG)/' | \
    $(SED) -n 's,^.*twolame/\([0-9][^"]*\)/".*$$,\1,p' | \
    head -n 1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --enable-static \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        CFLAGS="-DLIBTWOLAME_STATIC"
    $(MAKE) -C '$(1)' -j '$(JOBS)' SUBDIRS=libtwolame
    $(MAKE) -C '$(1)' -j 1 install SUBDIRS=libtwolame
endef

$(PKG)_BUILD_SHARED =
