# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := grantlee
$(PKG)_WEBSITE  := https://github.com/steveire/grantlee
$(PKG)_DESCR    := Grantlee is a set of Free Software libraries written using the Qt framework
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.2.0
$(PKG)_CHECKSUM := 139acee5746b957bdf1327ec0d97c604d4c0b9be42aec5d584297cb5ed6a990a
$(PKG)_GH_CONF  := steveire/grantlee/tags,v
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
         $($(PKG)_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
 endef