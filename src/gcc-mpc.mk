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
$(PKG)_DEPS     := gcc-gmp gcc-mpfr

define $(PKG)_UPDATE
    echo $(mpc_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)' \
        --disable-shared \
        --with-gmp='$(PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef

$(PKG)_BUILD_$(BUILD) =
