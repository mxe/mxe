# This file is part of MXE. See LICENSE.md for licensing information.

# override relevant cloog, isl, and gcc variables changed in:
# https://github.com/mxe/mxe/pull/965
#
# simply expanded variables (*_SUBDIR, *_FILE, etc.) need to be set

PKG             := cloog
$(PKG)_TARGETS  := $(MXE_TARGETS)

PKG             := isl
$(PKG)_VERSION  := 0.16.1
$(PKG)_CHECKSUM := 412538bb65c799ac98e17e8cfcdacbb257a57362acfaaff254b0fcae970126d2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://libisl.sourceforge.io/$($(PKG)_FILE)
$(PKG)_URL_2    := https://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)

PKG             := gcc
$(PKG)_VERSION  := 12.5.0
$(PKG)_RELEASE  := $($(PKG)_VERSION)
$(PKG)_CHECKSUM := 71cd373d0f04615e66c5b5b14d49c1a4c1a08efa7b30625cd240b11bab4062b3
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/sourceware.org/pub/gcc/snapshots/LATEST-12/$($(PKG)_FILE)
$(PKG)_PATCHES  := $(dir $(lastword $(MAKEFILE_LIST)))/gcc12.patch
$(PKG)_DEPS     := binutils mingw-w64 $(addprefix $(BUILD)~,gmp isl mpc mpfr zstd)

_$(PKG)_CONFIGURE_OPTS = --with-zstd='$(PREFIX)/$(BUILD)'

# copy db-2-install-exe.patch to gcc7 plugin when gcc10 is default
db_PATCHES := $(TOP_DIR)/src/db-1-fix-including-winioctl-h-lowcase.patch

# set these in respective makefiles when gcc10 becomes default
# remove from here and leave them blank for gcc5 plugin
libssh_EXTRA_WARNINGS = -Wno-error=implicit-fallthrough
gtkimageview_EXTRA_WARNINGS = -Wno-error=misleading-indentation
guile_EXTRA_WARNINGS = -Wno-error=misleading-indentation
gtkmm2_EXTRA_WARNINGS = -Wno-error=cast-function-type
gtkmm3_EXTRA_WARNINGS = -Wno-error=cast-function-type
gtkglextmm_EXTRA_WARNINGS = -Wno-error=cast-function-type
