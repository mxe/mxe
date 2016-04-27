# This file is part of MXE.
# See index.html for further information.

# override relevant cloog, isl, and gcc variables changed in:
# https://github.com/mxe/mxe/pull/965
#
# simply expanded variables (*_SUBDIR, *_FILE, etc.) need to be set
# libmysqlclient patch changes don't adversely affect 5.2 series

PKG             := cloog
$(PKG)_TARGETS  := $(MXE_TARGETS)

PKG             := isl
$(PKG)_VERSION  := 0.15
$(PKG)_CHECKSUM := 8ceebbf4d9a81afa2b4449113cee4b7cb14a687d7a549a963deb5e2a41458b6b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://isl.gforge.inria.fr/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)

PKG             := gcc
$(PKG)_VERSION  := 5.3.0
$(PKG)_CHECKSUM := b84f5592e9218b73dbae612b5253035a7b34a9a1f7688d2e1bfaaf7267d5c4db
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
