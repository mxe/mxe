# This file is part of MXE.
# See index.html for further information.

PKG             := qjson
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 197ccfd533f17bcf40428e68a82e6622047ed4ab
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
    echo '$(PREFIX)/$(TARGET)/qt/bin/qmake'
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=STATIC

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
