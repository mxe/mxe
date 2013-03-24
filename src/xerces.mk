# This file is part of MXE.
# See index.html for further information.

PKG             := xerces
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 177ec838c5119df57ec77eddec9a29f7e754c8b2
$(PKG)_SUBDIR   := xerces-c-$($(PKG)_VERSION)
$(PKG)_FILE     := xerces-c-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://apache.linux-mirror.org/xerces/c/$(word 1,$(subst ., ,$($(PKG)_VERSION)))/sources/$($(PKG)_FILE)
$(PKG)_URL_2    := http://www.apache.org/dist/xerces/c/$(word 1,$(subst ., ,$($(PKG)_VERSION)))/sources/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv curl pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.apache.org/dist/xerces/c/3/sources/?C=M;O=D' | \
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
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-xerces.exe' \
        `'$(TARGET)-pkg-config' xerces-c --cflags --libs`
endef
