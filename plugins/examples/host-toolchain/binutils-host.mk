# This file is part of MXE.
# See index.html for further information.

PKG             := binutils-host
$(PKG)_IGNORE    = $(binutils_IGNORE)
$(PKG)_VERSION   = $(binutils_VERSION)
$(PKG)_CHECKSUM  = $(binutils_CHECKSUM)
$(PKG)_SUBDIR    = $(binutils_SUBDIR)
$(PKG)_FILE      = $(binutils_FILE)
$(PKG)_URL       = $(binutils_URL)
$(PKG)_URL_2     = $(binutils_URL_2)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo $(binutils_VERSION)
endef

define $(PKG)_BUILD
    $(subst --disable-werror,\
            --disable-werror \
            --prefix='$(PREFIX)/$(TARGET)' \
            --host='$(TARGET)',\
    $(binutils_BUILD))

    #rm -rf '$(PREFIX)/$(TARGET)/$(TARGET)'
endef
