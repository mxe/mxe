# This file is part of MXE.
# See doc/index.html for further information.

# TagLib
PKG             := taglib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.1
$(PKG)_CHECKSUM := bafe0958eb884981cade83d45c18ee34165479b8
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://developer.kde.org/~wheeler/taglib.html
$(PKG)_URL      := http://developer.kde.org/~wheeler/files/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://developer.kde.org/~wheeler/files/src/?C=M;O=D' | \
    $(SED) -n 's,.*"taglib-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DENABLE_STATIC=ON
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
