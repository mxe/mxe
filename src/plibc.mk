# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := plibc
$(PKG)_WEBSITE  := https://plibc.sourceforge.io/
$(PKG)_DESCR    := Plibc
$(PKG)_IGNORE   := %
$(PKG)_VERSION  := cd7ed09
$(PKG)_CHECKSUM := 1e939804e173b8f789e1403964211835b8006253d0a541d55256b540639b0629
$(PKG)_SUBDIR   := mirror-plibc-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mirror/plibc/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, mirror/plibc, master)

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --includedir='$(PREFIX)/$(TARGET)/include/plibc' \
        --enable-static \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

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

$(PKG)_BUILD_SHARED =
