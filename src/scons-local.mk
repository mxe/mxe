# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := scons-local
$(PKG)_WEBSITE  := https://scons.org/
$(PKG)_DESCR    := Standalone SCons
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.1
$(PKG)_CHECKSUM := 4d6ceb7b5a628c0ffd9e7b5b0d176a4949cd70dd70ddd0cc0d18e19d71258695
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/scons/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TYPE     := source-only
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://scons.org/pages/download.html,scons-local-)
endef

# unpack sources into build dir and execute directly with python2
