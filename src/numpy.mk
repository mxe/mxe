# This file is part of MXE.
# See index.html for further information.

PKG             := numpy
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c36c471f44cf914abdf37137d158bf3ffa460141
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/numpy/files/NumPy/$($(PKG)_VERSION)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc python 


define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/numpy/files/NumPy/' | \
    $(SED) -n 's_.*/numpy.\([0-9].[0-9].[0-9]\).tar.gz.*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

	cd '$(1)'

	exit -1 

endef

