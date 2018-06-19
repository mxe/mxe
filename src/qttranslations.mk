# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qttranslations
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 12d89b2afa64dce4d32c9e680135243c579d99aa9279d2aafc5602c15a697106
$(PKG)_SUBDIR    = $(subst qtbase,qttranslations,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qttranslations,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qttranslations,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qttools

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

