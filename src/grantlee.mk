# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := grantlee
$(PKG)_WEBSITE  := https://github.com/steveire/grantlee
$(PKG)_DESCR    := Grantlee is a set of Free Software libraries written using the Qt framework
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.0
$(PKG)_CHECKSUM := 3836572fe5e49d28a1d99186c6d96f88ff839644b4bc77b73b6d8208f6ccc9d1
$(PKG)_GH_CONF  := steveire/grantlee/tags,v
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
         $($(PKG)_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
 endef