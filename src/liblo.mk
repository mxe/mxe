# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := liblo
$(PKG)_WEBSITE  := https://liblo.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.36
$(PKG)_CHECKSUM := c08d14832e8dcf8f06840405824a4f9611a0cb3daed0198946326c740941c8b6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/liblo/files/liblo/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)'/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)
endef
