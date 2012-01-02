# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libMikMod
PKG             := libmikmod
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.0-beta2
$(PKG)_CHECKSUM := f16fc09ee643af295a8642f578bda97a81aaf744
$(PKG)_SUBDIR   := libmikmod-$($(PKG)_VERSION)
$(PKG)_FILE     := libmikmod-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://mikmod.raphnet.net/
$(PKG)_URL      := http://mikmod.raphnet.net/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://mikmod.raphnet.net/' | \
    $(SED) -n 's,.*libmikmod-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,-Dunix,,' '$(1)/libmikmod/Makefile.in'
    $(SED) -i 's,`uname`,MinGW,g' '$(1)/configure'
    cd '$(1)' && \
        CC='$(TARGET)-gcc' \
        NM='$(TARGET)-nm' \
        RANLIB='$(TARGET)-ranlib' \
        STRIP='$(TARGET)-strip' \
        ./configure \
            --disable-shared \
            --prefix='$(PREFIX)/$(TARGET)' \
            --libdir='$(PREFIX)/$(TARGET)/lib' \
            --disable-esd
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libmikmod.exe' \
        `'$(PREFIX)/$(TARGET)/bin/libmikmod-config' --cflags --libs`
endef
