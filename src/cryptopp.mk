# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cryptopp
$(PKG)_WEBSITE  := https://www.cryptopp.com/
$(PKG)_DESCR    := Crypto++ Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.6.3
$(PKG)_CHECKSUM := 9390670a14170dd0f48a6b6b06f74269ef4b056d4718a1a329f6f6069dc957c9
$(PKG)_SUBDIR   :=
$(PKG)_VERSIONF := $(shell echo $($(PKG)_VERSION) | tr -d .)
$(PKG)_FILE     := $(PKG)$($(PKG)_VERSIONF).zip
$(PKG)_URL      := $(SOURCEFORGE_MIRROR)/cryptopp/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.cryptopp.com/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.cryptopp.com/' | \
    $(SED) -n 's,<TITLE>Crypto++ Library \([0-9]\.[0-9]\.[0-9]\).*,\1,p'
endef

define $(PKG)_BUILD
    cp '$(1)'config.recommend '$(1)'config.h
    $(MAKE) -C '$(1)' -j '$(JOBS)' -f GNUmakefile \
        CC=$(TARGET)-gcc \
        CXX=$(TARGET)-g++ \
        RANLIB=$(TARGET)-ranlib \
        AR=$(TARGET)-ar \
        LD=$(TARGET)-ld \
        CXXFLAGS='-DNDEBUG -O3 -mtune=native -pipe' \
        $(if $(BUILD_STATIC),libcryptopp.a,cryptopp.dll)

    $(INSTALL) -d '$(PREFIX)'/$(TARGET)/include/cryptopp
    $(INSTALL) '$(1)'*.h '$(PREFIX)'/$(TARGET)/include/cryptopp
    $(INSTALL) '$(1)'$(if $(BUILD_STATIC),libcryptopp.a,libcryptopp.dll.a) '$(PREFIX)'/$(TARGET)/lib
    $(if $(BUILD_STATIC),,$(INSTALL) '$(1)'cryptopp.dll '$(PREFIX)'/$(TARGET)/bin)

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'prefix=$(PREFIX)/$(TARGET)'; \
     echo 'exec_prefix=$${prefix}'; \
     echo 'libdir=$${exec_prefix}/lib'; \
     echo 'includedir=$${prefix}/include'; \
     echo ''; \
     echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: Crypto++ Library'; \
     echo 'Libs: -L$${libdir} -lcryptopp'; \
     echo 'Cflags: -I$${includedir}';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    $(TARGET)-g++ \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config cryptopp --cflags --libs`
endef
