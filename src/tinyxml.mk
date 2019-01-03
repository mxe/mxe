# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tinyxml
$(PKG)_WEBSITE  := https://sourceforge.net/projects/tinyxml/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.2
$(PKG)_CHECKSUM := 15bdfdcec58a7da30adc87ac2b078e4417dbe5392f3afb719f9ba6d062645593
$(PKG)_SUBDIR   := $(PKG)
$(PKG)_FILE     := $(PKG)_$(subst .,_,$($(PKG)_VERSION)).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

$(PKG)_MESSAGE  :=*** tinyxml is deprecated - please use tinyxml2 ***

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/tinyxml/files/tinyxml/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' '$(1)'
    $(MAKE) -C '$(1).build' install

    '$(TARGET)-g++' \
        -Wall -DTIXML_USE_STL -ansi -pedantic \
        '$(1)/xmltest.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-tinyxml.exe' \
        -ltinyxml

endef
