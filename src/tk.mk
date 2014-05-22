# This file is part of MXE.
# See index.html for further information.

PKG             := tk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.6.1
$(PKG)_CHECKSUM := ecfcc20833c04d6890b14a7920a04d16f2123a51
$(PKG)_SUBDIR   := tk$($(PKG)_VERSION)
$(PKG)_FILE     := tk$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tcl/Tcl/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc tcl

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
    $(MAKE) -C '$(1)/win' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
