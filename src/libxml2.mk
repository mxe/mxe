# libxml2
# http://www.xmlsoft.org/

PKG            := libxml2
$(PKG)_VERSION := 2.7.2
$(PKG)_SUBDIR  := libxml2-$($(PKG)_VERSION)
$(PKG)_FILE    := libxml2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := ftp://xmlsoft.org/libxml2/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'ftp://xmlsoft.org/libxml2/' | \
    $(SED) -n 's,.*LATEST_LIBXML2_IS_\([0-9][^>]*\)</a>.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,`uname`,MinGW,g' -i '$(1)/xml2-config.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --without-debug \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-python
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
