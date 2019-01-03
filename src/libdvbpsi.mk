# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libdvbpsi
$(PKG)_WEBSITE  := https://www.videolan.org/developers/libdvbpsi.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.2
$(PKG)_CHECKSUM := ac4e39f2b9b1e15706ad261fa175a9430344d650a940be9aaf502d4cb683c5fe
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := https://download.videolan.org/pub/libdvbpsi/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.videolan.org/pub/libdvbpsi/' | \
    $(SED) -n 's,.*<a href="\([0-9][^<]*\)/".*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-release
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' SUBDIRS=src
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install SUBDIRS=src
endef
