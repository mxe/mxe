# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tk
$(PKG)_WEBSITE  := https://tcl.tk/
$(PKG)_OWNER    := https://github.com/highperformancecoder
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.6.9
$(PKG)_CHECKSUM := d3f9161e8ba0f107fe8d4df1f6d3a14c30cc3512dfc12a795daa367a27660dac
$(PKG)_SUBDIR   := tk$($(PKG)_VERSION)
$(PKG)_FILE     := tk$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/tcl/Tcl/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc tcl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/tcl/files/Tcl/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # autoreconf to treat unrecognized options as warnings
    cd '$(SOURCE_DIR)/win' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/win/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        --with-tcl='$(PREFIX)/$(TARGET)/lib' \
        $(if $(findstring x86_64,$(TARGET)), --enable-64bit) \
        CFLAGS='-D__MINGW_EXCPT_DEFINE_PSDK'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' LIBS='-lmincore -lnetapi32 -lz -ltclstub86 -limm32 -lcomctl32 -luuid -lole32'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install 
endef
