# This file is part of MXE.
# See index.html for further information.

PKG             := qtxmlpatterns
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 69f7f46f0072a35e67e820a3561b852b497a9d8f
$(PKG)_SUBDIR    = $(subst qtbase,qtxmlpatterns,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtxmlpatterns,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtxmlpatterns,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
