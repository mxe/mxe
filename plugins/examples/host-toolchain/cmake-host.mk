# This file is part of MXE.
# See index.html for further information.

PKG             := cmake-host
$(PKG)_IGNORE    = $(cmake_IGNORE)
$(PKG)_VERSION   = $(cmake_VERSION)
$(PKG)_CHECKSUM  = $(cmake_CHECKSUM)
$(PKG)_SUBDIR    = $(cmake_SUBDIR)
$(PKG)_FILE      = $(cmake_FILE)
$(PKG)_URL       = $(cmake_URL)
$(PKG)_URL_2     = $(cmake_URL_2)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo $(cmake_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(TARGET)-cmake' '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
