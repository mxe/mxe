# This file is part of MXE.
# See index.html for further information.

PKG             := qtquick1
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := a3e6784bf7b62deb770d4b8185ea4af972feb65b
$(PKG)_SUBDIR    = $(subst qtbase,qtquick1,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtquick1,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtquick1,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qtscript qtsvg qttools qtxmlpatterns

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
