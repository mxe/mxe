# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# LibTIFF
PKG             := tiff
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.9.3
$(PKG)_CHECKSUM := 0d1eef69e58711d77320921bcb4d447f52265dc1
$(PKG)_SUBDIR   := tiff-$($(PKG)_VERSION)
$(PKG)_FILE     := tiff-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.remotesensing.org/libtiff/
$(PKG)_URL      := http://ftp.remotesensing.org/libtiff/$($(PKG)_FILE)
$(PKG)_URL_2    := http://download.osgeo.org/libtiff/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg

define $(PKG)_UPDATE
    wget -q -O- 'http://www.remotesensing.org/libtiff/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
