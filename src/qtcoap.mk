# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtcoap
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = 5.15.16
$(PKG)_CHECKSUM := b7009e9b1791e94d2abfff2f4e4d1e1ad2441de4db7b7ee909eb76a1fc142707
$(PKG)_SUBDIR   := $(PKG)-everywhere-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.qt.io/archive/qt/5.15/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := cc qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
