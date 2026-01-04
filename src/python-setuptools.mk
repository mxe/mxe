# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := python-setuptools
$(PKG)_WEBSITE  := https://pypi.org/project/setuptools
$(PKG)_DESCR    := Easily download, build, install, upgrade, and uninstall Python packages
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3a3144f
$(PKG)_CHECKSUM := a2675f599c07e6b9edce4c4cfc88e1ecea1fb7ac4c6c7fadb1e7d4274b8156da
# LTS branch for python2 support
$(PKG)_GH_CONF  := pypa/setuptools/branches/maint/44.x
$(PKG)_DEPS     := python-conf
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_BUILD
    $(PYTHON_SETUP_INSTALL)
endef
