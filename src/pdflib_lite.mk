# PDFlib Lite
# http://www.pdflib.com/download/pdflib-family/pdflib-lite/

PKG            := pdflib_lite
$(PKG)_VERSION := 7.0.3
$(PKG)_SUBDIR  := PDFlib-Lite-$($(PKG)_VERSION)
$(PKG)_FILE    := PDFlib-Lite-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://www.pdflib.com/binaries/PDFlib/$(subst .,,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc zlib libpng tiff jpeg

define $(PKG)_UPDATE
    wget -q -O- 'http://www.pdflib.com/download/pdflib-family/pdflib-lite/' | \
    $(SED) -n 's,.*PDFlib-Lite-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,ac_sys_system=`uname -s`,ac_sys_system=MinGW,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-pnglib='$(PREFIX)/$(TARGET)' \
        --with-tifflib='$(PREFIX)/$(TARGET)' \
        --with-zlib='$(PREFIX)/$(TARGET)' \
        --without-openssl \
        --without-java \
        --without-py \
        --without-perl \
        --without-ruby \
        --without-tcl \
        --disable-php \
        --enable-cxx \
        --enable-large-files \
        CFLAGS='-D_IOB_ENTRIES=20'
    $(SED) 's,-DPDF_PLATFORM=[^ ]* ,,' -i '$(1)/config/mkcommon.inc'
    $(MAKE) -C '$(1)/libs' -j '$(JOBS)' all
    $(MAKE) -C '$(1)/libs' -j 1         install
endef
