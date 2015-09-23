# This file is part of MXE.
# See index.html for further information.

PKG             := poco
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.7p1
$(PKG)_CHECKSUM := 7037cc465744bf2fa73aca9cea14d1207f040de5ea8073dc266b06a73b3db8df
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://pocoproject.org/releases/$(PKG)-$(word 1,$(subst p, ,$($(PKG)_VERSION)))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc expat openssl pcre sqlite zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://pocoproject.org/download/' | \
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
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-poco.exe' \
        -lPocoFoundation
endef

$(PKG)_BUILD_SHARED =
