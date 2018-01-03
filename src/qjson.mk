# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qjson
$(PKG)_WEBSITE  := https://qjson.sourceforge.io/
$(PKG)_DESCR    := QJson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.1
$(PKG)_CHECKSUM := cd4db5b956247c4991a9c3e95512da257cd2a6bd011357e363d02300afc814d9
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/qjson/files/qjson/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' ..

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' QJson --cflags --libs`
endef
