# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtspeech
$(PKG)_WEBSITE   = $(qtbase_WEBSITE)
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := a1c125f9dde6817ae41be668973b8f365c20e1860d5924ea7736383c1578eead
$(PKG)_SUBDIR    = $(subst qtbase,qtspeech,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtspeech,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtspeech,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
