# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# cairomm
PKG             := cairomm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.6
$(PKG)_CHECKSUM := 5d23ed912b23c6e39d6d2aec444a44b90a67d2ba
$(PKG)_SUBDIR   := cairomm-$($(PKG)_VERSION)
$(PKG)_FILE     := cairomm-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://cairographics.org/cairomm/
$(PKG)_URL      := http://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc cairo libsigc++

define $(PKG)_UPDATE
    wget -q -O- 'http://cairographics.org/releases/' | \
    grep 'LATEST-cairomm-' | \
    $(SED) -n 's,.*"LATEST-cairomm-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
