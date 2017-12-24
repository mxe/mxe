# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pdflib_lite
$(PKG)_WEBSITE  := https://www.pdflib.com/download/free-software/pdflib-lite-7/
$(PKG)_DESCR    := PDFlib Lite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.5p3
$(PKG)_CHECKSUM := e5fb30678165d28b2bf066f78d5f5787e73a2a28d4902b63e3e07ce1678616c9
$(PKG)_SUBDIR   := PDFlib-Lite-$($(PKG)_VERSION)
$(PKG)_FILE     := PDFlib-Lite-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.pdflib.com/binaries/PDFlib/$(subst .,,$(word 1,$(subst p, ,$($(PKG)_VERSION))))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.pdflib.com/download/free-software/pdflib-lite-7/' | \
    $(SED) -n 's,.*PDFlib-Lite-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && aclocal -I config --install
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-openssl \
        --without-java \
        --without-py \
        --without-perl \
        --without-ruby \
        --without-tcl \
        --enable-cxx \
        --enable-large-files \
        CFLAGS='-D_IOB_ENTRIES=20'
    $(SED) -i 's,-DPDF_PLATFORM=[^ ]* ,,' '$(1)/config/mkcommon.inc'
    $(MAKE) -C '$(1)/libs' -j '$(JOBS)'
    $(MAKE) -C '$(1)/libs' -j 1 install
endef

$(PKG)_BUILD_SHARED =
