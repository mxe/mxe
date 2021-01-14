# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cryptopp
$(PKG)_WEBSITE  := https://www.cryptopp.com/
$(PKG)_DESCR    := Crypto++ Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.4.0
$(PKG)_CHECKSUM := 6687dfc1e33b084aeab48c35a8550b239ee5f73a099a3b6a0918d70b8a89e654
$(PKG)_GH_CONF  := weidai11/cryptopp/tags,CRYPTOPP_,,,_
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' -f GNUmakefile \
        PREFIX='$(PREFIX)/$(TARGET)' \
        CC=$(TARGET)-gcc \
        CXX=$(TARGET)-g++ \
        RANLIB=$(TARGET)-ranlib \
        AR=$(TARGET)-ar \
        LD=$(TARGET)-ld \
        CXXFLAGS='-DNDEBUG -O3 -mtune=native -pipe' \
        libcryptopp.a

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/cryptopp'
    $(INSTALL) '$(SOURCE_DIR)/'*.h '$(PREFIX)/$(TARGET)/include/cryptopp'

    $(if $(BUILD_STATIC),\
        $(INSTALL) -m644 '$(SOURCE_DIR)/libcryptopp.a' '$(PREFIX)/$(TARGET)/lib/' \
    $(else), \
        $(MAKE_SHARED_FROM_STATIC) --ld '$(TARGET)-g++' '$(SOURCE_DIR)/libcryptopp.a')

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
