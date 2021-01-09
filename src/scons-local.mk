# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := scons-local
$(PKG)_WEBSITE  := https://scons.org/
$(PKG)_DESCR    := Standalone SCons
# scons 4x requires python3.5+ while 3x supports both 2.7+/3.5+
$(PKG)_IGNORE   := 4%
$(PKG)_VERSION  := 3.1.2
$(PKG)_CHECKSUM := 642e90860b746fa18fac08c7a22de6bfa86110ae7c56d7f136f7e5fb0d8f4f44
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/scons/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TYPE     := source-only
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://scons.org/pages/download.html,scons-local-)
endef

# unpack sources into build dir and execute directly with python2
# scons does various PATH manipulations that don't play well with ccache
SCONS_LOCAL = \
    PATH='$(PREFIX)/bin:$(PATH)' $(BUILD)-python$(PY_XY_VER) '$(BUILD_DIR).scons/scons.py'
SCONS_PREP = \
    mkdir -p '$(BUILD_DIR).scons' && \
    $(call PREPARE_PKG_SOURCE,scons-local,'$(BUILD_DIR).scons')
PKG_SCONS_OPTS = \
    $(_$(PKG)_SCONS_OPTS) \
    $($(PKG)_SCONS_OPTS)
