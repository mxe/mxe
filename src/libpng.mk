# libpng

PKG             := libpng
$(PKG)_VERSION  := 1.2.37
$(PKG)_CHECKSUM := 4e2a967a24db88e9a2f6a8bab3fa1fd94bc68c00
$(PKG)_SUBDIR   := libpng-$($(PKG)_VERSION)
$(PKG)_FILE     := libpng-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.libpng.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/libpng/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://libpng.git.sourceforge.net/git/gitweb.cgi?p=libpng;a=tags' | \
    grep '<a class="list name"' | \
    $(SED) -n 's,.*<a[^>]*>v\([0-9][^>]*\)<.*,\1,p' | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
