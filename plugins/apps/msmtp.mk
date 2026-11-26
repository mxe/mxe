# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := msmtp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.34
$(PKG)_CHECKSUM := 84e8fe2a5a80a1ee7802013b3fbdb846a3f27a4163cf37a1c6d7c7f888873ead
$(PKG)_GH_CONF  := marlam/msmtp/tags,msmtp-
# The archive from GitHub lacks the generated configure script, so use Marlam's
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://marlam.de/msmtp/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gnutls libgcrypt libgpg_error libgsasl libiconv libidn2 libntlm

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --infodir='$(BUILD_DIR)/sink' \
        --disable-nls \
        --without-libsecret \
        --without-macosx-keyring \
        --with-tls=gnutls \
        --with-libidn2 \
        CFLAGS='-Wno-incompatible-pointer-types'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_DOCS)
endef
