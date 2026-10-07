# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := grantlee
$(PKG)_WEBSITE  := https://github.com/steveire/grantlee
$(PKG)_DESCR    := Grantlee is a set of Free Software libraries written using the Qt framework
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.3.1
$(PKG)_CHECKSUM := ba288ae9ed37ec0c3622ceb40ae1f7e1e6b2ea89216ad8587f0863d64be24f06
$(PKG)_GH_CONF  := steveire/grantlee/tags,v
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
         $($(PKG)_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
 endef