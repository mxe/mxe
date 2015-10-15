# This file is part of MXE.
# See index.html for further information.

PKG             := log4cxx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.0
$(PKG)_CHECKSUM := 0de0396220a9566a580166e66b39674cb40efd2176f52ad2c65486c99c920c8c
$(PKG)_SUBDIR   := apache-log4cxx-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://www.eu.apache.org/dist/logging/log4cxx/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := http://apache.mirror.cdnetworks.com//logging/log4cxx/0.10.0/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc apr-util

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://logging.apache.org/log4cxx/download.html' | \
    $(SED) -n 's,.*log4cxx-\([0-9.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --enable-static \
        --with-apr='$(PREFIX)/$(TARGET)' \
        --with-apr-util='$(PREFIX)/$(TARGET)' \
        CFLAGS=-D_WIN32_WINNT=0x0500 \
        CXXFLAGS=-D_WIN32_WINNT=0x0500
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
    mkdir -p '$(PREFIX)/$(TARGET)/share/cmake/log4cxx'
    cp '$(1)/log4cxx-config.cmake' '$(PREFIX)/$(TARGET)/share/cmake/log4cxx/log4cxx-config.cmake'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-log4cxx.exe' \
        `$(TARGET)-pkg-config liblog4cxx --libs`
endef

$(PKG)_BUILD_SHARED =
