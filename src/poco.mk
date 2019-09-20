# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := poco
$(PKG)_WEBSITE  := https://pocoproject.org/
$(PKG)_DESCR    := POCO C++ Libraries
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.4
$(PKG)_CHECKSUM := 1bcaff7b1f7dfcbe573ddf0bf7e251e93072355ecc468c075339920c97e39c8f
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
