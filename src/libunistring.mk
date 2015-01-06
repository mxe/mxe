# This file is part of MXE.
# See index.html for further information.

PKG             := libunistring
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.3
$(PKG)_CHECKSUM := e1ea13c24a30bc93932d19eb5ad0704a618506dd
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/gitweb/?p=$(PKG).git;a=tags' | \
    grep '<a class="list name"' | \
    $(SED) -n 's,.*<a[^>]*>v\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-threads=win32
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
