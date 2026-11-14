# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gcc
$(PKG)_WEBSITE  := https://gcc.gnu.org/
$(PKG)_DESCR    := GCC
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 10.5.0
$(PKG)_RELEASE  := $($(PKG)_VERSION)
$(PKG)_CHECKSUM := 25109543fdf46f397c347b5d8b7a2c7e5694a5a51cce4b9c6e1ea8a71ca307c1
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_PATCHES  := $(dir $(lastword $(MAKEFILE_LIST)))/gcc-1-fixes.patch
$(PKG)_DEPS     := binutils mingw-w64 $(addprefix $(BUILD)~,gmp isl mpc mpfr zstd)

_$(PKG)_CONFIGURE_OPTS = \
    --with-zstd='$(PREFIX)/$(BUILD)' \
    CFLAGS_FOR_TARGET='-Wno-error=format -Wno-error=format-extra-args -DHAVE_VSNPRINTF=1' \
    CXXFLAGS_FOR_TARGET='-Wno-error=format -Wno-error=format-extra-args -DHAVE_VSNPRINTF=1'

# Shared GCC build logic. Must be included at the end of the file
# so it can access the package variables defined above.
include $(TOP_DIR)/plugins/gcc-common/gcc-common.mk
