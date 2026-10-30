# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cimg
$(PKG)_WEBSITE  := http://cimg.eu/
$(PKG)_DESCR    := CImg Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.7
$(PKG)_CHECKSUM := 32b93f038681f7e489af5d2e0a7937a32c90e020d0d9fc01f7d5badf430e6697
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
