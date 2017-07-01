# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt5
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_DEPS     := $(patsubst $(TOP_DIR)/src/%.mk,%,\
                        $(shell grep -l 'qtbase_VERSION' \
                                $(TOP_DIR)/src/qt*.mk \
                                --exclude '$(TOP_DIR)/src/qt5.mk'))
