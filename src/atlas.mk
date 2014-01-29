# This file is part of MXE.
# See index.html for further information.

PKG             := atlas
$(PKG)_VERSION  := 3.10.1
$(PKG)_CHECKSUM := cd5bfb06af3de60de1226078a9247684b44d0451
$(PKG)_SUBDIR   := ATLAS
$(PKG)_FILE     := $(PKG)$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/math-atlas/Stable/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/math-atlas/files/Stable/' | \
    $(SED) -n 's,.*<a href="/projects/math-atlas/files/Stable/\([0-9.]*\)\/">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --shared \
        --help
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
