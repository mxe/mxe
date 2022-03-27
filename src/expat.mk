# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := expat
$(PKG)_WEBSITE  := https://github.com/libexpat/libexpat
$(PKG)_DESCR    := Expat XML Parser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.7
$(PKG)_CHECKSUM := e149bdd8b90254c62b3d195da53a09bd531a4d63a963b0d8a5268d48dd2f6a65
$(PKG)_SUBDIR   := expat-$($(PKG)_VERSION)
$(PKG)_FILE     := expat-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/expat/expat/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://github.com/libexpat/libexpat/releases/download/R_$(subst .,_,$($(PKG)_VERSION))/$($(PKG)_FILE)
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
