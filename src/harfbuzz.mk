# This file is part of MXE.
# See index.html for further information.

PKG             := harfbuzz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.2
$(PKG)_CHECKSUM := 4a2c5790bd3db7c3ca8c02e4858f2fd592df7932c1d2fa9f6b99acbce0f8461f
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
    # mman-win32 is only a partial implementation
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        ac_cv_header_sys_mman_h=no \
        LIBS='-lstdc++'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
