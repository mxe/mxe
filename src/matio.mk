# This file is part of MXE.
# See index.html for further information.

PKG             := matio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.2
$(PKG)_CHECKSUM := db02d0fb3373c3d766a606309b17e64a5d8da55610e921a9f1a0ec171e911d45
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc hdf5 zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/matio/files/matio/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
