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
$(PKG)_VERSION  := 0.14
$(PKG)_CHECKSUM := 7e3c02ff52f8540f6a85534f54158968417fd676001651c8289c705bd0228f36
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://isl.gforge.inria.fr/$($(PKG)_FILE)

PKG             := gcc
$(PKG)_VERSION  := 5.2.0
$(PKG)_CHECKSUM := 5f835b04b5f7dd4f4d2dc96190ec1621b8d89f2dc6f638f9f8bc1b1014ba8cad
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
