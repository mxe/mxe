# This file is part of MXE.
# See index.html for further information.

PKG             := plibc
$(PKG)_IGNORE   := %
$(PKG)_VERSION  := cd7ed09
$(PKG)_CHECKSUM := 303afa33721e2d0e92044e18f36bb3b57f48da35
$(PKG)_SUBDIR   := mirror-plibc-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mirror/plibc/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

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
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-plibc.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs plibc`
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
