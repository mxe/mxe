# This file is part of MXE.
# See index.html for further information.

PKG             := mysql-connector-c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.1.5
$(PKG)_CHECKSUM := 710bf076b77bfd67a97395fee26833bc861bc112
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)-src
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://dev.mysql.com/get/Downloads/Connector-C/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD 
mkdir '$(1).build' 
cd '$(1).build' && cmake -G "Unix Makefiles" -DSKIP_SSL=1 -DSTACK_DIRECTION=1 -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET) '$(1)' 
$(MAKE) -C '$(1).build' -j '$(JOBS)' VERBOSE=1 
$(MAKE) -C '$(1).build' -j 1 install VERBOSE=1 
endef 

$(PKG)_BUILD_SHARED =
