# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt5
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_DEPS     := $(subst qt5, qtbase, \
                      $(patsubst $(dir $(lastword $(MAKEFILE_LIST)))/%.mk,%,\
                          $(shell grep -l 'qtbase_VERSION' \
                              $(dir $(lastword $(MAKEFILE_LIST)))/qt*.mk)))
