# This file is part of MXE.
# See index.html for further information.

PKG             := bfd
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
    cd '$(1)/bfd' && ./configure \
        --host='$(TARGET)' \
        --target='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-install-libbfd \
        --disable-shared
    $(MAKE) -C '$(1)/bfd' -j '$(JOBS)'
    $(MAKE) -C '$(1)/bfd' -j 1 install
endef

$(PKG)_BUILD_SHARED =
