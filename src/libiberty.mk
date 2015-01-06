# This file is part of MXE.
# See index.html for further information.

PKG             := libiberty
$(PKG)_IGNORE    = $(binutils_IGNORE)
$(PKG)_VERSION   = $(binutils_VERSION)
$(PKG)_CHECKSUM  = $(binutils_CHECKSUM)
$(PKG)_SUBDIR    = $(binutils_SUBDIR)/libiberty
$(PKG)_FILE      = $(binutils_FILE)
$(PKG)_URL       = $(binutils_URL)
$(PKG)_URL_2     = $(binutils_URL_2)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo $(binutils_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --enable-static \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-install-libiberty
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install target_header_dir=libiberty

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libiberty.exe' \
        -I$(PREFIX)/$(TARGET)/include/libiberty -liberty
endef

$(PKG)_BUILD_SHARED =
