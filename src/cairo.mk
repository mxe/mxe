# cairo
# http://cairographics.org/

PKG            := cairo
$(PKG)_VERSION := 1.8.6
$(PKG)_SUBDIR  := cairo-$($(PKG)_VERSION)
$(PKG)_FILE    := cairo-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc zlib libpng fontconfig freetype pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://cairographics.org/releases/' | \
    grep 'LATEST-cairo-' | \
    $(SED) -n 's,.*"LATEST-cairo-\([1-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-gtk-doc
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
