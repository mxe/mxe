# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# PDFlib Lite
PKG             := pdflib_lite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.5
$(PKG)_CHECKSUM := 5b2bf5edc49dba3da0997ade0e191511a37fae01
$(PKG)_SUBDIR   := PDFlib-Lite-$($(PKG)_VERSION)
$(PKG)_FILE     := PDFlib-Lite-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.pdflib.com/download/free-software/pdflib-lite-7/
$(PKG)_URL      := http://www.pdflib.com/binaries/PDFlib/$(subst .,,$(word 1,$(subst p, ,$($(PKG)_VERSION))))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.pdflib.com/download/free-software/pdflib-lite-7/' | \
    $(SED) -n 's,.*PDFlib-Lite-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,ac_sys_system=`uname -s`,ac_sys_system=MinGW,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
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
    $(SED) -i 's,-DPDF_PLATFORM=[^ ]* ,,' '$(1)/config/mkcommon.inc'
    $(MAKE) -C '$(1)/libs' -j '$(JOBS)'
    $(MAKE) -C '$(1)/libs' -j 1 install
endef
