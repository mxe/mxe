# This file is part of MXE.
# See index.html for further information.

PKG             := qttranslations
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 1561d8495aa29003240819a8cf6d7a64ff96a9b7
$(PKG)_SUBDIR    = $(subst qtbase,qttranslations,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qttranslations,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qttranslations,$(qtbase_URL))
$(PKG)_DEPS     := gcc qtbase qttools

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
