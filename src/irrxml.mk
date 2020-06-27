# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := irrxml
$(PKG)_WEBSITE  := https://www.ambiera.com/irrxml/index.html
$(PKG)_DESCR    := IrrLicht SDK XML parser.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2
$(PKG)_CHECKSUM := 9b4f80639b2dee3caddbf75862389de684747df27bea7d25f96c7330606d7079
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/irrlicht/irrXML%20SDK/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)'&& $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef