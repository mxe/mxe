# gettext
# http://www.gnu.org/software/gettext/

PKG            := gettext
$(PKG)_VERSION := 0.17
$(PKG)_SUBDIR  := gettext-$($(PKG)_VERSION)/gettext-runtime
$(PKG)_FILE    := gettext-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := ftp://ftp.gnu.org/pub/gnu/gettext/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'ftp://ftp.gnu.org/pub/gnu/gettext/' | \
    $(SED) -n 's,.*gettext-\([0-9][^>]*\)\.tar.*,\1,p' | \
    sort | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads=win32
    $(MAKE) -C '$(1)/intl' -j '$(JOBS)' install
endef
