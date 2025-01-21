# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cfitsio
$(PKG)_WEBSITE  := https://heasarc.gsfc.nasa.gov/fitsio/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.5.0
$(PKG)_CHECKSUM := e4854fc3365c1462e493aa586bfaa2f3d0bb8c20b75a524955db64c27427ce09
$(PKG)_SUBDIR   := cfitsio-$($(PKG)_VERSION)
$(PKG)_FILE     := cfitsio-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/?C=M;O=D" | \
    grep -i '<a href="cfitsio.*tar' | \
    $(SED) -n 's,.*cfitsio-\([0-9.][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        '-DUSE_PTHREADS=ON'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: A FITS File Subroutine Library'; \
     echo 'Libs: -l$(PKG) -lz';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-cfitsio.exe' \
        `'$(TARGET)-pkg-config' cfitsio --cflags --libs`
endef
