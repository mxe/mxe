# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := poco
$(PKG)_WEBSITE  := https://pocoproject.org/
$(PKG)_DESCR    := POCO C++ Libraries
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.4-all
$(PKG)_CHECKSUM := eb34f257b11240a711ee505f1d80c754a80a990aeb48d8d93407884df288fd77
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://pocoproject.org/releases/$(PKG)-$(subst -all,,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat openssl pcre sqlite zlib libmysqlclient

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://pocoproject.org/download/' | \
    $(SED) -n 's,.*poco-\([0-9][^>/]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # We need to pass the -mbig-obj flag to the assembler in order to avoid potential "File too" errors
    #
    # PageCompiler fails during linking as it tries to find a "WinMain" function and in order for ODBC to work,
    # there has to a ODBC client installed/available and currently there is none in MXE.
    #
    cd '$(1)' && ./configure \
        --config=MinGW-CrossEnv \
        --static \
        --unbundled \
        --prefix='$(PREFIX)/$(TARGET)' \
        --no-tests \
        --no-samples \
        --cflags="-Wa,-mbig-obj" \
        --omit=PageCompiler,Data/ODBC
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
