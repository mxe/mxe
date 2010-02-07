# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# TDM-GCC
PKG             := gcc-tdm
$(PKG)_IGNORE   := 4.4.1-tdm-2
$(PKG)_VERSION  := 4.4.0-tdm-1
$(PKG)_CHECKSUM := ec1c81acf0581b4f1e2d5498ce9cd015b63e917b
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := gcc-$($(PKG)_VERSION)-srcbase-2.zip
$(PKG)_WEBSITE  := http://www.tdragon.net/recentgcc/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tdm-gcc/Sources/TDM Sources/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/tdm-gcc/files/Sources/) | \
    $(SED) -n 's,.*gcc-\([0-9][^>]*\)-srcbase[-0-9]*\.zip.*,\1,p' | \
    tail -1
endef
