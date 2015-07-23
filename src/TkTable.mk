# This file is part of MXE.
# See index.html for further information.

PKG             := TkTable
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.11.D3
$(PKG)_CHECKSUM := ea4a2e8796cf604d0cc7a943f21811214b28d796
$(PKG)_SUBDIR   := $(PKG).$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG).$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/minsky/files/Sources/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc tk

# Note, the official tktable project at
# https://sourceforge.net/projects/tktable/ appears to be abandoned,
# with the last release dated 15/11/2008.

# The releases hosted by the Minsky project are privately maintained by Russell
# Standish, and based of the CVS head, with a couple of important
# patches.

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/minsky/files/Sources/' | \
    $(SED) -n 's,.*TkTable\.\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-shared \
        --with-tcl=$(PREFIX)/$(TARGET)/lib --with-tk=$(PREFIX)/$(TARGET)/lib
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    cp $(1)/libTktable2.11.a $(PREFIX)/$(TARGET)/lib
endef
