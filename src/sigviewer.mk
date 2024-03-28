# This file is part of MXE.
# See index.html for further information.

PKG             := sigviewer
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.6.4
$(PKG)_CHECKSUM := e64516b0d5a2ac65b1ef496a6666cdac8919b67eecd8d5eb6b7cbf2493314367
$(PKG)_SUBDIR   := sigviewer-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/cbrnr/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_QT_DIR   := qt5
$(PKG)_DEPS     := biosig libxdf qtbase

define $(PKG)_UPDATE
    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip'
    head -1
endef

define $(PKG)_BUILD
    #    LIBS='-l$(PREFIX)/$(TARGET)/lib/libtinyxml.a -l$(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/plugins/platforms/libqwindows.a'
    cd '$(1)' && CFLAGS=-fstack-protector CXXFLAGS=-fstack-protector && \
        LIBS='-l$(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/plugins/platforms/libqwindows.a' \
        $(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/bin/qmake sigviewer.pro

    $(MAKE) -C '$(1)'

    $(INSTALL) '$(1)'/bin/release/sigviewer.exe $(PREFIX)/$(TARGET)/bin/$(PKG).exe
endef
