# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gcc
$(PKG)_WEBSITE  := https://gcc.gnu.org/
$(PKG)_DESCR    := GCC
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.5.0
$(PKG)_RELEASE  := $($(PKG)_VERSION)
$(PKG)_CHECKSUM := b81946e7f01f90528a1f7352ab08cc602b9ccc05d4e44da4bd501c5a189ee661
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_PATCHES  := $(dir $(lastword $(MAKEFILE_LIST)))/gcc-1-fixes.patch
$(PKG)_DEPS     := binutils mingw-w64 $(addprefix $(BUILD)~,gmp isl mpc mpfr)

_$(PKG)_CONFIGURE_OPTS = \
    CFLAGS_FOR_TARGET='-Wno-error=format -Wno-error=format-extra-args -DHAVE_VSNPRINTF=1' \
    CXXFLAGS_FOR_TARGET='-Wno-error=format -Wno-error=format-extra-args -DHAVE_VSNPRINTF=1'

# The following warning flags are defined in src/*.mk for modern GCCs.
# Since legacy GCC compilers do not support them and would fail with an
# "unrecognized command line option" error, we must explicitly clear them here.
gtkmm2_EXTRA_WARNINGS =
gtkmm3_EXTRA_WARNINGS =
gtkglextmm_EXTRA_WARNINGS =

# Shared GCC build logic. Must be included at the end of the file 
# so it can access the package variables defined above.
include $(TOP_DIR)/plugins/gcc-common/gcc-common.mk
