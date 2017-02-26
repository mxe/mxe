# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := harfbuzz
$(PKG)_WEBSITE  := http://harfbuzz.sourceforge.net/
$(PKG)_DESCR    := HarfBuzz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.3
$(PKG)_CHECKSUM := 838c17400a88a3a451eb401573ef94cdd50919730d98255547c459fef1d85321
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.freedesktop.org/software/$(PKG)/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cairo freetype-bootstrap glib icu4c

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cgit.freedesktop.org/harfbuzz/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=[^0-9]*\\([0-9.]*\\)'.*,\\1,p" | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # prevent interference from previous install
    rm -rf '$(PREFIX)/$(TARGET)/lib/pkgconfig/harfbuzz'*.pc '$(PREFIX)/$(TARGET)/include/harfbuzz' '$(PREFIX)/$(TARGET)/lib/libharfbuzz'* '$(PREFIX)/$(TARGET)/bin/libharfbuzz'*.dll
    # mman-win32 is only a partial implementation
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        ac_cv_header_sys_mman_h=no \
        LIBS='-lstdc++'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
