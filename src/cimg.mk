# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cimg
$(PKG)_WEBSITE  := http://cimg.eu/
$(PKG)_DESCR    := CImg Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.7.6
$(PKG)_CHECKSUM := ff1711da822b2b5f3bb68eed7c9b6b6c9391a7865ef6e34cf3e05659834ff0f3
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
