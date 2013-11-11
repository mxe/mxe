# This file is part of MXE.
# See index.html for further information.

PKG             := plibc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.7
$(PKG)_CHECKSUM := b545c602dc5b381fcea9d096910dede95168fbeb
$(PKG)_SUBDIR   := PlibC-$($(PKG)_VERSION)
$(PKG)_FILE     := plibc-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/plibc/files/plibc/$($(PKG)_VERSION)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://sourceforge.net/projects/plibc/files/plibc/" | \
    grep 'plibc/files/plibc' | \
    $(SED) -n 's,.*plibc/\([0-9][^>]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    chmod 0755 '$(1)/configure'
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
     echo 'Libs.private: -lws2_32 -lole32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/plibc.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-plibc.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs plibc`
endef

$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =
