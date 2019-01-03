# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := poco
$(PKG)_WEBSITE  := https://pocoproject.org/
$(PKG)_DESCR    := POCO C++ Libraries
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.0
$(PKG)_CHECKSUM := 8b42a9010911da6a6e036093c372ee94ffd30cd1c08b552eb34680a595e15c98
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://pocoproject.org/releases/$(PKG)-$(word 1,$(subst p, ,$($(PKG)_VERSION)))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat openssl pcre sqlite zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://pocoproject.org/download/' | \
    $(SED) -n 's,.*poco-\([0-9][^>/]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --config=MinGW-CrossEnv \
        --static \
        --unbundled \
        --prefix='$(PREFIX)/$(TARGET)' \
        --no-tests \
        --no-samples
    $(if $(BUILD_STATIC), \
        $(SED) -i 's:// #define POCO_STATIC:#define POCO_STATIC:' \
            '$(1)/Foundation/include/Poco/Config.h')
    $(MAKE) -C '$(1)' -j '$(JOBS)' -k CROSSENV=$(TARGET) || $(MAKE) -C '$(1)' -j 1 CROSSENV=$(TARGET)
    $(MAKE) -C '$(1)' -j 1 install CROSSENV=$(TARGET)

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic -DPOCO_STATIC=1 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-poco.exe' \
        -lPocoFoundation
endef

$(PKG)_BUILD_SHARED =
