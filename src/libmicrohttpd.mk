# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libmicrohttpd
$(PKG)_WEBSITE  := https://www.gnu.org/software/libmicrohttpd/
$(PKG)_DESCR    := GNU Libmicrohttpd
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.10
$(PKG)_CHECKSUM := 04bfe8ef75db7d629a33de767599765cecadc56274a39822d5d081030d577685
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/libmicrohttpd/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/libmicrohttpd/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gnutls plibc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/libmicrohttpd/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="libmicrohttpd-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-doc \
        --disable-examples \
        --disable-tools \
        CFLAGS='$(if $(BUILD_STATIC),-DGNUTLS_INTERNAL_BUILD,)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' PROGRAMS=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic -Wno-error=unused-parameter -Wno-incompatible-pointer-types \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libmicrohttpd.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs libmicrohttpd`
endef
