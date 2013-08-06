# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-mpc
$(PKG)_IGNORE    = $(mpc_IGNORE)
$(PKG)_VERSION   = $(mpc_VERSION)
$(PKG)_CHECKSUM  = $(mpc_CHECKSUM)
$(PKG)_SUBDIR    = $(mpc_SUBDIR)
$(PKG)_FILE      = $(mpc_FILE)
$(PKG)_URL       = $(mpc_URL)
$(PKG)_URL_2     = $(mpc_URL_2)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo $(mpc_VERSION)
endef
