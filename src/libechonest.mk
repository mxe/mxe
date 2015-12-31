# This file is part of MXE.
# See index.html for further information.

PKG             := libechonest
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := ab961ab952df30c5234b548031594d7e281e7c9f2a9d1ce91fe5421ddde85e7c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/lfranchi/libechonest/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qt qjson

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/lfranchi/libechonest/archive/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/"\.tar.*,\1,p' | \
    sort | uniq | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef

$(PKG)_BUILD_STATIC =
