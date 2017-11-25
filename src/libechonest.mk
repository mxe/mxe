# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libechonest
$(PKG)_WEBSITE  := https://github.com/lfranchi/libechonest
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.1
$(PKG)_CHECKSUM := ab961ab952df30c5234b548031594d7e281e7c9f2a9d1ce91fe5421ddde85e7c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/lfranchi/$(PKG)/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc qjson qt

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, lfranchi/libechonest)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $(PKG)'; \
     echo 'Requires: QtCore QtNetwork'; \
     echo 'Libs: -lechonest';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libechonest --cflags --libs`
endef

$(PKG)_BUILD_STATIC =
