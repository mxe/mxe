# This file is part of MXE.
# See index.html for further information.

PKG             := matplotlib
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1d0c319b2bc545f1a7002f56768e5730fe573518
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://downloads.sourceforge.net/project/matplotlib/matplotlib/$($(PKG)_SUBDIR)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc python libpng freetype wxpython numpy 


define $(PKG)_UPDATE
    wget -q -O- 'http://matplotlib.org/downloads.html' | \
    $(SED) -n 's_.*">matplotlib.\([0-9].[0-9].[0-9]\).tar.gz</a>.*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

	cd '$(1)'
	
	exit -1 

endef

