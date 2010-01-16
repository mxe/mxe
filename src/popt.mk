# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# popt
PKG             := popt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.15
$(PKG)_CHECKSUM := d9bc3067a4e7e62ac0bd9818e8cd649ee0dd12dc
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://freshmeat.net/projects/popt/
$(PKG)_URL      := http://rpm5.org/files/popt/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv gettext

define $(PKG)_UPDATE
    wget -q -O- 'http://rpm5.org/files/popt/' | \
    grep 'popt-' | \
    $(SED) -n 's,.*popt-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
