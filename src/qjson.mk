# This file is part of MXE.
# See index.html for further information.

PKG             := qjson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.1
$(PKG)_CHECKSUM := cd4db5b956247c4991a9c3e95512da257cd2a6bd011357e363d02300afc814d9
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/qjson/files/qjson/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
