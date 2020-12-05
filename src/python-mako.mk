# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := python-mako
$(PKG)_WEBSITE  := https://www.makotemplates.org
$(PKG)_DESCR    := Mako Templates for Python
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.3
$(PKG)_CHECKSUM := 6da59743c4839715fd87b0f6047c37d7a1dc18ed34249313213bad82b833e212
$(PKG)_GH_CONF  := sqlalchemy/mako/tags,rel_,,,_
$(PKG)_DEPS     := python-conf $(BUILD)~python-markupsafe
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_BUILD
    $(PYTHON_SETUP_INSTALL)
endef
