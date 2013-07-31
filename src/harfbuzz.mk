# This file is part of MXE.
# See index.html for further information.

PKG             := harfbuzz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.19
$(PKG)_CHECKSUM := 5603e084fbf8be1b93722c8e2694643361c489e4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.freedesktop.org/software/$(PKG)/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib cairo freetype icu4c

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cgit.freedesktop.org/harfbuzz/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-static \
        LIBS='-lstdc++'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
