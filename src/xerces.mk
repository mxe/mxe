# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xerces
$(PKG)_WEBSITE  := https://xerces.apache.org/xerces-c/
$(PKG)_DESCR    := Xerces-C++
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.4
$(PKG)_CHECKSUM := c98eedac4cf8a73b09366ad349cb3ef30640e7a3089d360d40a3dde93f66ecf6
$(PKG)_SUBDIR   := xerces-c-$($(PKG)_VERSION)
$(PKG)_FILE     := xerces-c-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://archive.apache.org/dist/xerces/c/$(word 1,$(subst ., ,$($(PKG)_VERSION)))/sources/$($(PKG)_FILE)
$(PKG)_DEPS     := cc curl libiconv pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.apache.org/dist/xerces/c/3/sources/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="xerces-c-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v rc | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CONFIG_SHELL='$(SHELL)' ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --disable-sse2 \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-libtool-lock \
        --disable-pretty-make \
        --enable-threads \
        --enable-network \
        --enable-netaccessor-curl \
        --disable-netaccessor-socket \
        --disable-netaccessor-cfurl \
        --disable-netaccessor-winsock \
        --enable-transcoder-iconv \
        --disable-transcoder-gnuiconv \
        --disable-transcoder-icu \
        --disable-transcoder-macosunicodeconverter \
        --disable-transcoder-windows \
        --enable-msgloader-inmemory \
        --disable-msgloader-iconv \
        --disable-msgloader-icu \
        --with-curl='$(PREFIX)/$(TARGET)' \
        --without-icu \
        LIBS="`$(TARGET)-pkg-config --libs libcurl`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-xerces.exe' \
        `'$(TARGET)-pkg-config' xerces-c --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
