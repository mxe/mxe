# This file is part of MXE.
# See index.html for further information.

PKG             := qtserialport_qt4
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtserialport_VERSION)
$(PKG)_CHECKSUM  = $(qtserialport_CHECKSUM)
$(PKG)_SUBDIR    = $(qtserialport_SUBDIR)
$(PKG)_FILE      = $(qtserialport_FILE)
$(PKG)_URL       = $(qtserialport_URL)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
    echo $(qtserialport_VERSION)
endef

define $(PKG)_BUILD_SHARED
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
