# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-isl
$(PKG)_IGNORE    = $(isl_IGNORE)
$(PKG)_VERSION   = $(isl_VERSION)
$(PKG)_CHECKSUM  = $(isl_CHECKSUM)
$(PKG)_SUBDIR    = $(isl_SUBDIR)
$(PKG)_FILE      = $(isl_FILE)
$(PKG)_URL       = $(isl_URL)
$(PKG)_URL_2     = $(isl_URL_2)
$(PKG)_DEPS     := gcc-gmp

define $(PKG)_UPDATE
    echo $(isl_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)' \
        --disable-shared \
        --with-gmp-prefix='$(PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef

$(PKG)_BUILD_$(BUILD) =
