# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtmultimedia
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 3347791521b106d1e69ac0b28ea9a295c06dddcf592c051d366fedc9ae73e0bb
$(PKG)_SUBDIR    = $(subst qtbase,qtmultimedia,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtmultimedia,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtmultimedia,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' \
        -after \
        'LIBS_PRIVATE += -lamstrmid'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
