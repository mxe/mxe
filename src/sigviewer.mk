# This file is part of MXE.
# See index.html for further information.

PKG             := sigviewer
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.6.3
$(PKG)_CHECKSUM := 5fb5dfb84574920fc8bbdfd9d6c30b136e501cfd5a9f71a8790d6fac49ebac3c
#ddbe6a96802af73c0cee8dfc80d3ba4ca47f9bce9492713cf6da6aa049244b09
$(PKG)_SUBDIR   := sigviewer-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/cbrnr/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_QT_DIR   := qt5
$(PKG)_DEPS     := libbiosig libxdf qtbase

define $(PKG)_UPDATE
#    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
#    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip'
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CFLAGS=-fstack-protector CXXFLAGS=-fstack-protector && \
        LIBS='-l$(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/plugins/platforms/libqwindows.a' \
        $(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/bin/qmake sigviewer.pro

    $(MAKE) -C '$(1)'

    $(INSTALL) '$(1)'/bin/release/sigviewer.exe $(PREFIX)/$(TARGET)/bin/$(PKG).exe
endef
