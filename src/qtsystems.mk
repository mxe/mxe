# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := qtsystems
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 66e4567
$(PKG)_CHECKSUM := 20c98396ad7c5d819e98a6b34935ab2c0eed25e701dc062ac37d2b8d20b71bfb
$(PKG)_GH_CONF  := qt/qtsystems/branches/dev
$(PKG)_DEPS     := cc qtbase qtdeclarative qtxmlpatterns

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/syncqt.pl' -version 5.4.0
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
