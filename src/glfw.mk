# This file is part of MXE.
# See index.html for further information.

PKG             := glfw
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.4
$(PKG)_CHECKSUM := 9b04309418ccbc74b2115d11198b7912669814ee
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.sourceforge.net/project/glfw/glfw/$($(PKG)_VERSION)/$($(PKG)_FILE)?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2F$(PKG)%2Ffiles%2F$(PKG)%2F$(PKG)_VERSION)%2F&ts=1406664584&use_mirror=garr
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)' -j $(JOBS)
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
