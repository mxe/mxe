# This file is part of MXE.
# See index.html for further information.

PKG             := id3lib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.3
$(PKG)_CHECKSUM := 2749cc3c0cd7280b299518b1ddf5a5bcfe2d1100614519b68702230e26c7d079
$(PKG)_SUBDIR   := id3lib-$($(PKG)_VERSION)
$(PKG)_FILE     := id3lib-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/id3lib/files/id3lib/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
