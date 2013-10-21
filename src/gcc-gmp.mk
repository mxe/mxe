# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-gmp
$(PKG)_IGNORE    = $(gmp_IGNORE)
$(PKG)_VERSION   = $(gmp_VERSION)
$(PKG)_CHECKSUM  = $(gmp_CHECKSUM)
$(PKG)_SUBDIR    = $(gmp_SUBDIR)
$(PKG)_FILE      = $(gmp_FILE)
$(PKG)_URL       = $(gmp_URL)
$(PKG)_URL_2     = $(gmp_URL_2)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo $(gmp_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)' \
        --disable-shared
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef

$(PKG)_BUILD_$(BUILD) =
