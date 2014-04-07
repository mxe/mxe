# This file is part of MXE.
# See index.html for further information.

PKG             := libiconv
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14
$(PKG)_CHECKSUM := be7d67e50d72ff067b2c0291311bc283add36965
$(PKG)_SUBDIR   := libiconv-$($(PKG)_VERSION)
$(PKG)_FILE     := libiconv-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/libiconv/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.gnu.org/software/libiconv/' | \
    grep 'libiconv-' | \
    $(SED) -n 's,.*libiconv-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's, sed , $(SED) ,g' '$(1)/windows/windres-options'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-nls
    $(MAKE) -C '$(1)/libcharset' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/lib'        -j '$(JOBS)' install
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/include/iconv.h.inst' '$(PREFIX)/$(TARGET)/include/iconv.h'
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' man1_MANS=
    $(MAKE) -C '$(1).build' -j 1 install man1_MANS=
endef
