# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gcc
$(PKG)_WEBSITE  := https://gcc.gnu.org/
$(PKG)_DESCR    := GCC
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 16.2.0
$(PKG)_RELEASE  := $($(PKG)_VERSION)
$(PKG)_CHECKSUM := e6738e29597f733270731aa90600f37ffdc045079dfc27ec7e8192cc81085c3e
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_PATCHES  := $(dir $(lastword $(MAKEFILE_LIST)))/gcc16.patch
$(PKG)_DEPS     := binutils mingw-w64 $(addprefix $(BUILD)~,gmp isl mpc mpfr zstd)

_$(PKG)_CONFIGURE_OPTS = --with-zstd='$(PREFIX)/$(BUILD)' --enable-tls

# Shared GCC build logic. Must be included at the end of the file 
# so it can access the package variables defined above.
include $(TOP_DIR)/plugins/gcc-common/gcc-common.mk
