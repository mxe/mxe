# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libid3tag
$(PKG)_WEBSITE  := https://sourceforge.net/projects/mad/files/libid3tag/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.15.1b
$(PKG)_CHECKSUM := 63da4f6e7997278f8a3fef4c6a372d342f705051d1eeb6a46a86b03610e26151
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/mad/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/mad/files/libid3tag/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # configure script is ancient so regenerate
    touch '$(SOURCE_DIR)'/{NEWS,AUTHORS,ChangeLog}
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' LDFLAGS='-no-undefined'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
