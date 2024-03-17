# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := expat
$(PKG)_WEBSITE  := https://github.com/libexpat/libexpat
$(PKG)_DESCR    := Expat XML Parser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.2
$(PKG)_CHECKSUM := 9c7c1b5dcbc3c237c500a8fb1493e14d9582146dd9b42aa8d3ffb856a3b927e0
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

    # Remove cmake folder since we're not using cmake here and it's
    # prebuilt misconfigured for MXE
    $(RM) -r '$(PREFIX)/$(TARGET)/lib/cmake/expat-$($(PKG)_VERSION)'

endef
