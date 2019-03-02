# This file is part of MXE. See LICENSE.md for licensing information.
PKG             := qtsystems
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := e3332ee
$(PKG)_CHECKSUM := 29101923081aa57d994cdb1ba4b6128cef82f5e310f81c280c1acd6442a1fc38
$(PKG)_GH_CONF  := qt/qtsystems/branches/dev
$(PKG)_DEPS     := cc qtbase qtdeclarative qtxmlpatterns

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/syncqt.pl' -version 5.4.0
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
