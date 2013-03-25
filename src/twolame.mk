# This file is part of MXE.
# See index.html for further information.

PKG             := twolame
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3ca460472c2f6eeedad70291d8e37da88b64eb8b
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
