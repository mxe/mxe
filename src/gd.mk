# This file is part of MXE.
# See index.html for further information.

PKG             := gd
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := 66c56fc07246b66ba649c83e996fd2085ea2f9e2
$(PKG)_SUBDIR   := libgd-$($(PKG)_VERSION)
$(PKG)_FILE     := libgd-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://bitbucket.org/libgd/gd-libgd/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc fontconfig freetype jpeg libpng libvpx pthreads tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://bitbucket.org/libgd/gd-libgd/downloads/' | \
    $(SED) -n 's,.*libgd-\([0-9.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,-I@includedir@,-I@includedir@ -DNONDLL -DBGDWIN32,' '$(1)/config/gdlib-config.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-freetype='$(PREFIX)/$(TARGET)' \
        --without-x \
        CFLAGS='-DNONDLL'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gd.exe' \
        `'$(PREFIX)/$(TARGET)/bin/gdlib-config' --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
