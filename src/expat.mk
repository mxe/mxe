# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := expat
$(PKG)_WEBSITE  := https://github.com/libexpat/libexpat
$(PKG)_DESCR    := Expat XML Parser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.9
$(PKG)_CHECKSUM := f1063084dc4302a427dabcca499c8312b3a32a29b7d2506653ecc8f950a9a237
$(PKG)_SUBDIR   := expat-$($(PKG)_VERSION)
$(PKG)_FILE     := expat-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/expat/expat/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/expat/files/expat/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-docbook
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
