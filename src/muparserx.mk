# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := muparserx
$(PKG)_WEBSITE  := http://muparserx.beltoforion.de/
$(PKG)_DESCR    := muParserX
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.4
$(PKG)_CHECKSUM := d7ebcab8cb1de88e6dcba21651db8f6055b3e904c45afc387b06b5f4218dda40
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/beltoforion/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, beltoforion/muparserx, v)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-cmake' \
        -DBUILD_EXAMPLES=OFF
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
