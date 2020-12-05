# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := python-setuptools
$(PKG)_WEBSITE  := https://pypi.org/project/setuptools
$(PKG)_DESCR    := Easily download, build, install, upgrade, and uninstall Python packages
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := df51e62
$(PKG)_CHECKSUM := 238ee37579c7e07a3057cb92e223982b9c513d590908ee54e1d8ecbe2a496639
# LTS branch for python2 support
$(PKG)_GH_CONF  := pypa/setuptools/branches/maint/44.x
$(PKG)_DEPS     := python-conf
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && $(BUILD)-python$(PY_XY_VER) bootstrap.py
    $(PYTHON_SETUP_INSTALL)
endef
