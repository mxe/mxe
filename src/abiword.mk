# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := abiword
$(PKG)_VERSION  := 3.0.2
$(PKG)_CHECKSUM := afbfd458fd02989d8b0c6362ba8a4c14686d89666f54cfdb5501bd2090cf3522
$(PKG)_SUBDIR   := abiword-$($(PKG)_VERSION)
$(PKG)_FILE     := abiword-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.abisource.org/downloads/abiword/3.0.2/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 enchant libffi fribidi glib libgsf libiconv jpeg lzma pcre libpng libxml2

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS=-DG_OS_WIN32
    WINDRES='$(TARGET)-windres' $(MAKE) -C '$(1)' -j 1 install
endef
