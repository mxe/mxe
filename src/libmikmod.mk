# This file is part of MXE.
# See index.html for further information.

PKG             := libmikmod
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 6d30f59019872699bdcc9bcf6893eea9d6b12c13
$(PKG)_SUBDIR   := libmikmod-$($(PKG)_VERSION)
$(PKG)_FILE     := libmikmod-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://mikmod.shlomifish.org/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://mikmod.shlomifish.org/' | \
    $(SED) -n 's,.*libmikmod-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,`uname`,MinGW,g' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        CONFIG_SHELL='$(SHELL)' \
        CFLAGS='-msse2'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libmikmod.exe' \
        `'$(PREFIX)/$(TARGET)/bin/libmikmod-config' --cflags --libs`
endef
