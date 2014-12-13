# This file is part of MXE.
# See index.html for further information.

PKG             := tinyxml2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.0
$(PKG)_CHECKSUM := 7869aa08241ce16f93ba3732c1cde155b1f2b6a0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/leethomason/tinyxml2/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/leethomason/tinyxml2/releases' | \
    $(SED) -n 's,.*/archive/\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        $(if $(BUILD_STATIC), \
            -DBUILD_STATIC_LIBS=ON)

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef