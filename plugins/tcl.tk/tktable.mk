# This file is part of MXE. See LICENSE.md for further information.

PKG             := tktable
$(PKG)_OWNER    := https://github.com/highperformancecoder
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.11.D3
$(PKG)_CHECKSUM := fb9fcedd2c1e252653225ac235d50cad01083b6851206bb0e5e63ecfa575fd5e
$(PKG)_SUBDIR   := TkTable.$($(PKG)_VERSION)
$(PKG)_FILE     := TkTable.$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/minsky/files/Sources/$($(PKG)_FILE)
$(PKG)_DEPS     := cc tk

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
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-x \
        --with-tcl=$(PREFIX)/$(TARGET)/lib \
        --with-tk=$(PREFIX)/$(TARGET)/lib
    # bizarrely, the Makefile links against -lX11 for no reason, even if
    # --without-x is specified
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' LIBS=
    $(MAKE) -C '$(BUILD_DIR)'  PKG_DIR= install
endef
