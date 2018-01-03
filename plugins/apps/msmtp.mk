# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := msmtp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.6
$(PKG)_CHECKSUM := da15db1f62bd0201fce5310adb89c86188be91cd745b7cb3b62b81a501e7fb5e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_OWNER    := https://github.com/andrew-strong
$(PKG)_DEPS     := cc gnutls libgcrypt libgpg_error libgsasl libiconv libidn libntlm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/msmtp/files/msmtp/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --infodir='$(BUILD_DIR)/sink' \
        --disable-nls \
        --without-libsecret \
        --without-macosx-keyring \
        --with-tls=gnutls \
        --with-libidn
    $(MAKE) -C $(BUILD_DIR) -j '$(JOBS)'
    $(MAKE) -C $(BUILD_DIR) -j 1 install $(MXE_DISABLE_DOCS)
endef
