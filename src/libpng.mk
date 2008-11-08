# libpng
# http://www.libpng.org/

PKG            := libpng
$(PKG)_VERSION := 1.2.25
$(PKG)_SUBDIR  := libpng-$($(PKG)_VERSION)
$(PKG)_FILE    := libpng-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/libpng/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=5624&package_id=5683' | \
    grep 'libpng-' | \
    $(SED) -n 's,.*libpng-\([0-9][^>]*\)-no-config\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
