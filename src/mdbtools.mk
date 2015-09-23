# This file is part of MXE.
# See index.html for further information.

PKG             := mdbtools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.1
$(PKG)_CHECKSUM := 4eac1bce55066a38d9ea6c52a8e8ecc101b79afe75118ecc16852990472c4721
$(PKG)_SUBDIR   := brianb-mdbtools-f8ce1cc
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://github.com/brianb/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/brianb/mdbtools/tags' | \
    grep '<a href="/brianb/mdbtools/archive/' | \
    $(SED) -n 's,.*href="/brianb/mdbtools/archive/\([0-9][^"_]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -i -f
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --disable-man \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA= || \
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=
endef

$(PKG)_BUILD_SHARED =
