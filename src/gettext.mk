# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# gettext
PKG             := gettext
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.17
$(PKG)_CHECKSUM := c51803d9f745f6ace36bd09c0486d5735ce399cf
$(PKG)_SUBDIR   := gettext-$($(PKG)_VERSION)
$(PKG)_FILE     := gettext-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.gnu.org/software/gettext/
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gettext/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gnu.org/software/gettext/' | \
    grep 'gettext-' | \
    $(SED) -n 's,.*gettext-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/gettext-runtime' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads=win32 \
        --without-libexpat-prefix \
        --without-libxml2-prefix
    $(MAKE) -C '$(1)/gettext-runtime/intl' -j '$(JOBS)' SHELL=bash install
endef
