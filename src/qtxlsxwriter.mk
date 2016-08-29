# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := qtxlsxwriter
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3c474f376d1eb098793c45c2f512b216e696052b
$(PKG)_CHECKSUM := 9b9dc38ec4817dcc8e720276ea590a5b39f27908b67e8bfdb98b946b2f35ef67
$(PKG)_SUBDIR   := QtXlsxWriter-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/VSRonin/QtXlsxWriter/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc qtbase

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, VSRonin/QtXlsxWriter, master)

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
