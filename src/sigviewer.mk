# This file is part of MXE.
# See index.html for further information.

PKG             := sigviewer
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.7.1
$(PKG)_CHECKSUM := 43b8f68fa8e3c91a1b5af8302a1306a51bc501dcc47621f34dc97862b1c5e176
$(PKG)_SUBDIR   := sigviewer-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/cbrnr/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_QT_DIR   := qt6
$(PKG)_DEPS     := biosig libxdf qt6-qtbase qt6-qtsvg

define $(PKG)_UPDATE
    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip'
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_BUILD_TYPE="Release"
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(INSTALL) '$(BUILD_DIR)'/sigviewer.exe $(PREFIX)/$(TARGET)/bin/
endef
