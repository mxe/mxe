# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libdvdnav
$(PKG)_WEBSITE  := https://www.videolan.org/developers/libdvdnav.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.0.0
$(PKG)_CHECKSUM := f0a2711b08a021759792f8eb14bb82ff8a3c929bf88c33b64ffcddaa27935618
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://download.videolan.org/pub/videolan/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libdvdread

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.videolan.org/pub/videolan/libdvdnav/' | \
    $(SED) -n 's,.*href="\([0-9][^<]*\)/".*,\1,p' | \
    grep -v 'alpha\|beta\|rc' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' LDFLAGS=-no-undefined
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install LDFLAGS=-no-undefined
endef
