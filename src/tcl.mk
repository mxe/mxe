# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tcl
$(PKG)_WEBSITE  := https://tcl.tk/
$(PKG)_OWNER    := https://github.com/highperformancecoder
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.6.10
$(PKG)_CHECKSUM := 5196dbf6638e3df8d5c87b5815c8c2b758496eb6f0e41446596c9a4e638d87ed
$(PKG)_SUBDIR   := tcl$($(PKG)_VERSION)
$(PKG)_FILE     := tcl$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/tcl/Tcl/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS_$(BUILD) := zlib

$(PKG)_SOURCE_SUBDIR  = $(if $(findstring mingw,$(TARGET)),win,unix)
$(PKG)_CONFIGURE_OPTS = $(if $(findstring mingw,$(TARGET)),CFLAGS=-D__MINGW_EXCPT_DEFINE_PSDK)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/tcl/files/Tcl/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # autoreconf to treat unrecognized options as warnings
    cd '$(SOURCE_DIR)/$($(PKG)_SOURCE_SUBDIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/$($(PKG)_SOURCE_SUBDIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        $(if $(findstring x86_64,$(TARGET)), --enable-64bit) \
        $($(PKG)_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' PKGS_DIR=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install install-private-headers PKGS_DIR=
endef
