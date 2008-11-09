# LibTIFF
# http://www.remotesensing.org/libtiff/

PKG            := tiff
$(PKG)_VERSION := 3.8.2
$(PKG)_SUBDIR  := tiff-$($(PKG)_VERSION)
$(PKG)_FILE    := tiff-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://download.osgeo.org/libtiff/$($(PKG)_FILE)
$(PKG)_URL_2   := ftp://ftp.remotesensing.org/pub/libtiff/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc pthreads zlib jpeg

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
        PTHREAD_LIBS='-lpthread -lws2_32' \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
