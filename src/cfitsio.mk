# This file is part of MXE.
# See index.html for further information.

PKG             := cfitsio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3370
$(PKG)_CHECKSUM := 092897c6dae4dfe42d91d35a738e45e8236aa3d8f9b3ffc7f0e6545b8319c63a
$(PKG)_SUBDIR   := cfitsio
$(PKG)_FILE     := cfitsio$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/?C=M;O=D" | \
    grep -i '<a href="cfitsio.*tar' | \
    $(SED) -n 's,.*cfitsio\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        FC='$(TARGET)-gfortran'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-cfitsio.exe' \
        `'$(TARGET)-pkg-config' cfitsio --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
