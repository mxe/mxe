# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := python-markupsafe
$(PKG)_WEBSITE  := https://palletsprojects.com/p/markupsafe
$(PKG)_DESCR    := Safely add untrusted strings to HTML/XML markup
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.1
$(PKG)_CHECKSUM := 222a10e3237d92a9cd45ed5ea882626bc72bc5e0264d3ed0f2c9129fa69fc167
$(PKG)_GH_CONF  := pallets/markupsafe/tags,,,a,
$(PKG)_DEPS     := python-conf $(BUILD)~python-setuptools
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_BUILD
    $(PYTHON_SETUP_INSTALL)
endef
