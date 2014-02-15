# This file is part of MXE.
# See index.html for further information.

PKG             := qtgraphicaleffects
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 649765bb8054abccbd1002606469f56bba5cab25
$(PKG)_SUBDIR    = $(subst qtbase,qtgraphicaleffects,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtgraphicaleffects,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtgraphicaleffects,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
