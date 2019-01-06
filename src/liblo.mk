# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := liblo
$(PKG)_WEBSITE  := https://liblo.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.29
$(PKG)_CHECKSUM := ace1b4e234091425c150261d1ca7070cece48ee3c228a5612d048116d864c06a
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
