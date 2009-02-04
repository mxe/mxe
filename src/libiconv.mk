# libiconv
# http://www.gnu.org/software/libiconv/

PKG            := libiconv
$(PKG)_VERSION := 1.12
$(PKG)_SUBDIR  := libiconv-$($(PKG)_VERSION)
$(PKG)_FILE    := libiconv-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://ftp.gnu.org/pub/gnu/libiconv/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gnu.org/software/libiconv/' | \
    grep 'libiconv-' | \
    $(SED) -n 's,.*libiconv-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's, sed , $(SED) ,g' -i '$(1)/windows/windres-options'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
