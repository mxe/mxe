# This file is part of MXE.
# See index.html for further information.

PKG             := tk
$(PKG)_WEBSITE  := https://tcl.tk
$(PKG)_OWNER    := https://github.com/highperformancecoder
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.6.4
$(PKG)_CHECKSUM := 08f99df85e5dc9c4271762163c6aabb962c8b297dc5c4c1af8bdd05fc2dd26c1
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
	$(if $(findstring x86_64,$(TARGET)), --enable-64bit) \
	CFLAGS=-D__MINGW_EXCPT_DEFINE_PSDK
    $(MAKE) -C '$(1)/win' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

