# This file is part of MXE.
# See index.html for further information.

PKG             := qjson
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 19bbef24132b238e99744bb35194c6dadece98f9
$(PKG)_SUBDIR   := $(PKG)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/qjson/files/qjson/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    echo '$(PREFIX)/bin/$(TARGET)-qmake'
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DLIBTYPE=STATIC

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef

$(PKG)_BUILD_i686-static-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32 = $($(PKG)_BUILD)
