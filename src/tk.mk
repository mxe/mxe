# This file is part of MXE.
# See index.html for further information.

PKG             := tk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.6.1
$(PKG)_CHECKSUM := ecfcc20833c04d6890b14a7920a04d16f2123a51
$(PKG)_SUBDIR   := tk$($(PKG)_VERSION)
$(PKG)_FILE     := tk$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tcl/Tcl/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := tcl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/tcl/files/Tcl/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    ## tk physically depends on the build dir of tcl
    ## here we rely on the tcl*-src.tar.gz still existing - it's a dependency
    mkdir -p $(call TMP_DIR,tcl)
    cd $(call TMP_DIR,tcl) && $(call UNPACK_ARCHIVE,$(PKG_DIR)/$(tcl_FILE))
    cd '$(1)/win' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --enable-threads \
        --enable-64bit \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-tcl='$(PREFIX)/$(TARGET)/lib'
    $(MAKE) -C '$(1)/win' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    rm -rfv $(call TMP_DIR,tcl)
endef
