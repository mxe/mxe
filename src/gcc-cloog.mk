# This file is part of MXE.
# See index.html for further information.

PKG             := gcc-cloog
$(PKG)_IGNORE    = $(cloog_IGNORE)
$(PKG)_VERSION   = $(cloog_VERSION)
$(PKG)_CHECKSUM  = $(cloog_CHECKSUM)
$(PKG)_SUBDIR    = $(cloog_SUBDIR)
$(PKG)_FILE      = $(cloog_FILE)
$(PKG)_URL       = $(cloog_URL)
$(PKG)_URL_2     = $(cloog_URL_2)
$(PKG)_DEPS     := gcc-gmp gcc-isl

define $(PKG)_UPDATE
    echo $(cloog_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)' \
        --disable-shared \
        --with-gmp-prefix='$(PREFIX)' \
        --with-isl-prefix='$(PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef

$(PKG)_BUILD_$(BUILD) =
