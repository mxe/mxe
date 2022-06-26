# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qt6
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt6
$(PKG)_VERSION   = $(qt6-qtbase_VERSION)
$(PKG)_TYPE     := meta
$(PKG)_DEPS     := $(patsubst $(dir $(lastword $(MAKEFILE_LIST)))/%.mk,%,\
                       $(shell grep -l 'QT6_METADATA' \
                           $(dir $(lastword $(MAKEFILE_LIST)))/qt6-qt*.mk))

# add order-only dep for conf
$(foreach dep,$(qt6_DEPS),\
    $(eval $(dep)_OO_DEPS += qt6-conf))
