# libiconv
# http://www.gnu.org/software/libiconv/

PKG            := libiconv
$(PKG)_VERSION := 1.11.1
$(PKG)_SUBDIR  := libiconv-$($(PKG)_VERSION)
$(PKG)_FILE    := libiconv-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://ftp.gnu.org/pub/gnu/libiconv/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://ftp.gnu.org/pub/gnu/libiconv/' | \
    $(SED) -n 's,.*libiconv-\([0-9]*\)\.\([0-9]*\)\(\.[0-9]*\)\.tar.*,\1.\2\3,p' | \
    sort -n | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
