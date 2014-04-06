# This file is part of MXE.
# See index.html for further information.

PKG             := libmicrohttpd
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.33
$(PKG)_CHECKSUM := 75f53089ba86b5aa4e4eeb2579c47fed6ca63c72
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/libmicrohttpd/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc plibc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/libmicrohttpd/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="libmicrohttpd-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --build="`config.guess`" \
        --host='$(TARGET)' \
        --enable-static \
        --disable-shared \
        CFLAGS="`'$(TARGET)-pkg-config' --cflags plibc`" \
        LIBS="`'$(TARGET)-pkg-config' --libs plibc`"
    $(MAKE) -C '$(1).build' -j '$(JOBS)' PROGRAMS=
    $(MAKE) -C '$(1).build' -j 1 install PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic -Wno-error=unused-parameter \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libmicrohttpd.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs libmicrohttpd`
endef

$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
