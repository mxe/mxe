# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cimg
$(PKG)_WEBSITE  := http://cimg.eu/
$(PKG)_DESCR    := CImg Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.1
$(PKG)_CHECKSUM := 3ff9805ca2534775e3a41acfff9b2c6435e43dce7e84c0532fcdff62a68481d3
$(PKG)_SUBDIR   := CImg-$($(PKG)_VERSION)
$(PKG)_FILE     := CImg_$($(PKG)_VERSION).zip
$(PKG)_URL      := http://cimg.eu/files/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cimg.eu/files/' | \
    $(SED) -n 's,.*CImg_\([0-9][^"]*\)\.zip.*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cp -r '$(SOURCE_DIR)/CImg.h' '$(SOURCE_DIR)/plugins' '$(PREFIX)/$(TARGET)/include/'

    # Build demo
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++11 -pedantic \
        -mwindows -lgdi32 \
        '$(SOURCE_DIR)/examples/CImg_demo.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe'
endef
