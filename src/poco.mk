# This file is part of MXE.
# See index.html for further information.

PKG             := poco
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.6p2
$(PKG)_CHECKSUM := 90042349faf1790b5167bad0e84e1713bfd46046
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
        --prefix='$(PREFIX)/$(TARGET)'
    $(if $(BUILD_STATIC), \
        $(SED) -i 's:// #define POCO_STATIC:#define POCO_STATIC:' \
            '$(1)/Foundation/include/Poco/Config.h')
    $(MAKE) -C '$(1)' -j '$(JOBS)' install CROSSENV=$(TARGET)

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic -DPOCO_STATIC=1 \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-poco.exe' \
        -lPocoFoundation
endef

$(PKG)_BUILD_SHARED =
