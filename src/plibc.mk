# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := plibc
$(PKG)_WEBSITE  := https://plibc.sourceforge.io/
$(PKG)_DESCR    := Plibc
$(PKG)_IGNORE   := %
$(PKG)_VERSION  := cd7ed09
$(PKG)_CHECKSUM := 1e939804e173b8f789e1403964211835b8006253d0a541d55256b540639b0629
$(PKG)_GH_CONF  := mirror/plibc/branches/master
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --includedir='$(PREFIX)/$(TARGET)/include/plibc' \
        CFLAGS='-DEHOSTDOWN=WSAEHOSTDOWN \
                -DESOCKTNOSUPPORT=WSAESOCKTNOSUPPORT \
                -DEPROCLIM=WSAEPROCLIM \
                -DEDQUOT=WSAEDQUOT \
                -DESTALE=WSAESTALE \
                -DECASECLASH=2137'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: PlibC'; \
     echo 'Cflags: -I''$(PREFIX)/$(TARGET)/include/plibc'' -DWINDOWS'; \
     echo 'Libs: -lplibc'; \
     echo 'Libs.private: -lws2_32 -lole32 -luuid';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/plibc.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-plibc.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs plibc`
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
