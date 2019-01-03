# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtserialport_qt4
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5c3b6cc
$(PKG)_CHECKSUM := d49c1cd4bb47706561f52c07d6075bb9931700d3bcae656ef3b6d3db3eb014ab
$(PKG)_GH_CONF  := qt/qtserialport/branches/qt4-dev
$(PKG)_DEPS     := cc qt

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    # install one of the test programs
    cp -f '$(1)/examples/serialport/cenumerator/release/cenumerator.exe' '$(PREFIX)/$(TARGET)/bin/test-qtserialport_qt4.exe'
endef
