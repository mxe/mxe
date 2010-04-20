# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# zlib
PKG             := zlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.4
$(PKG)_CHECKSUM := 8cf10521c1927daa5e12efc5e1725a0d70e579f3
$(PKG)_SUBDIR   := zlib-$($(PKG)_VERSION)
$(PKG)_FILE     := zlib-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://zlib.net/
$(PKG)_URL      := http://zlib.net/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://zlib.net/' | \
    $(SED) -n 's,.*zlib-\([0-9][^>]*\)\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CC='$(TARGET)-gcc' AR='$(TARGET)-ar' RANLIB='$(TARGET)-ranlib' ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --static
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
