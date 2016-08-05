# This file is part of MXE.
# See index.html for further information.

PKG             := tk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.6.4
$(PKG)_CHECKSUM := 08f99df85e5dc9c4271762163c6aabb962c8b297dc5c4c1af8bdd05fc2dd26c1
$(PKG)_SUBDIR   := $(PKG)$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := $(SOURCEFORGE_MIRROR)/tcl/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc tcl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.tcl.tk/software/tcltk/download.html' | \
    $(SED) -n 's,.*Tk \([0-9.]*\) Sources.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

# We need to unpack and configure Tcl in order for Tk to compile
define $(PKG)_BUILD
    cd '$(1)/..' && tar xzf $(PKG_DIR)/tcl$($(PKG)_VERSION)-src.tar.gz && \
    cd '$(1)'/../tcl$($(PKG)_VERSION)/win && ./configure \
    $(MXE_CONFIGURE_OPTS) \
    $(if $(findstring x86_64,$(TARGET)),--enable-64bit) && \
    $(MAKE) -C '$(1)'/../tcl$($(PKG)_VERSION)/win -j '$(JOBS)' binaries
    cd '$(1)/win' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(if $(findstring x86_64,$(TARGET)),--enable-64bit)
    $(MAKE) -C '$(1)/win' -j '$(JOBS)'
    $(MAKE) -C '$(1)/win' -j 1 install
endef
