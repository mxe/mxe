# This file is part of MXE.
# See index.html for further information.

PKG             := tcl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.6.1
$(PKG)_CHECKSUM := 16ee769248e64ba1cae6b4834fcc4e4edd7470d881410e8d58f7dd1434343514
$(PKG)_SUBDIR   := tcl$($(PKG)_VERSION)
$(PKG)_FILE     := tcl$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tcl/Tcl/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/tcl/files/Tcl/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/win' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        --without-sqlite\
        $(if $(findstring x86_64,$(TARGET)), --enable-64bit) \
        CFLAGS='-D__MINGW_EXCPT_DEFINE_PSDK'
    $(MAKE) -C '$(1)/win' install install-private-headers $(MXE_DISABLE_PROGRAMS)
endef
