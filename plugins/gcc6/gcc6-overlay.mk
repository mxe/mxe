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
$(PKG)_URL      := http://isl.gforge.inria.fr/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://gcc.gnu.org/pub/gcc/infrastructure/$($(PKG)_FILE)

PKG             := gcc
$(PKG)_VERSION  := 6.2.0
$(PKG)_CHECKSUM := 9944589fc722d3e66308c0ce5257788ebd7872982a718aa2516123940671b7c5
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
