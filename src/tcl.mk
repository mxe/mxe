# This file is part of MXE.
# See index.html for further information.

PKG             := tcl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.6.4
$(PKG)_CHECKSUM := 9e6ed94c981c1d0c5f5fefb8112d06c6bf4d050a7327e95e71d417c416519c8d
$(PKG)_SUBDIR   := $(PKG)$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := $(SOURCEFORGE_MIRROR)/tcl/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.tcl.tk/software/tcltk/download.html' | \
    $(SED) -n 's,.*Tcl \([0-9.]*\) Sources.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

# The packages aren't built.
# They have a fully fledge configure/make environment and should therefore be their own separate packages.
define $(PKG)_BUILD
    cd '$(1)/win' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
    $(if $(findstring x86_64,$(TARGET)),--enable-64bit)
    $(MAKE) -C '$(1)/win' -j '$(JOBS)' binaries libraries doc
    $(MAKE) -C '$(1)/win' -j 1 install-binaries install-libraries install-doc
endef
