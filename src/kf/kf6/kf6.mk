# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := kf6
$(PKG)_WEBSITE  := https://kde.org/
$(PKG)_DESCR    := KDE Frameworks 6
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := $(kf6-conf_VERSION)
$(PKG)_TYPE     := meta
$(PKG)_DEPS     := $(shell grep -l 'KF6_METADATA' $(dir $(lastword $(MAKEFILE_LIST)))/kf6-*.mk | \
                     sed -n 's,.*kf6-\(.*\)\.mk,\1,p' | \
                     grep -v '^conf$$' | \
                     sed 's,^,kf6-,g')

define $(PKG)_UPDATE
    echo $(kf6-conf_VERSION)
endef
