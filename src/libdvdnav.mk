# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libdvdnav
$(PKG)_WEBSITE  := https://www.videolan.org/developers/libdvdnav.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.0
$(PKG)_CHECKSUM := a2a18f5ad36d133c74bf9106b6445806fa253b09141a46392550394b647b221e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
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
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Denable_docs=false \
        -Denable_examples=false \
        $(PKG_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
