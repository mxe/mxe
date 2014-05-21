# This file is part of MXE.
# See index.html for further information.

PKG             := tcl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.6.1
$(PKG)_CHECKSUM := 5c83d44152cc0496cc0847a2495f659502a30e40
$(PKG)_SUBDIR   := tcl$($(PKG)_VERSION)
$(PKG)_FILE     := tcl$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tcl/Tcl/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sqlite

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/tcl/files/Tcl/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/win' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
	$(if $(findstring 64,$(TARGET)), --enable-64bit) \
	CFLAGS=-D__MINGW_EXCPT_DEFINE_PSDK
    $(MAKE) -C '$(1)/win' install install-private-headers bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
