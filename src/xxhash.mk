# This file is part of MXE.
# See index.html for further information.

PKG             := xxhash
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6.1
$(PKG)_CHECKSUM := a940123baa6c71b75b6c02836bae2155cd2f74f7682e1a1d6f7b889f7bc9e7f8
$(PKG)_SUBDIR   := xxHash-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/Cyan4973/xxHash/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, Cyan4973/xxHash) | \
    $(SED) 's,^v,,g'
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_STATIC_LIBS=$(CMAKE_STATIC_BOOL) \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        '$(1)/cmake_unofficial'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef

$(PKG)_BUILD_SHARED =