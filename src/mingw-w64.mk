# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mingw-w64
$(PKG)_WEBSITE  := https://mingw-w64.sourceforge.io/
$(PKG)_DESCR    := MinGW-w64 Runtime
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.3
$(PKG)_CHECKSUM := 2a601db99ef579b9be69c775218ad956a24a09d7dabc9ff6c5bd60da9ccc9cb4
$(PKG)_SUBDIR   := $(PKG)-v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-v$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-release/$($(PKG)_FILE)
$(PKG)_TYPE     := archive
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/' | \
    $(SED) -n 's,.*mingw-w64-v\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef
