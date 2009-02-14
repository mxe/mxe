# gettext
# http://www.gnu.org/software/gettext/

PKG            := gettext
$(PKG)_VERSION := 0.17
$(PKG)_SUBDIR  := gettext-$($(PKG)_VERSION)/gettext-runtime
$(PKG)_FILE    := gettext-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := ftp://ftp.gnu.org/pub/gnu/gettext/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gnu.org/software/gettext/' | \
    grep 'gettext-' | \
    $(SED) -n 's,.*gettext-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-libexpat-prefix \
        --enable-threads=win32
    $(MAKE) -C '$(1)/intl' -j '$(JOBS)' SHELL=bash install
endef
