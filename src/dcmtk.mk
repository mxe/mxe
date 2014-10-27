# This file is part of MXE.
# See index.html for further information.

PKG             := dcmtk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.0
$(PKG)_CHECKSUM := 469e017cffc56f36e834aa19c8612111f964f757
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://dicom.offis.de/pub/dicom/offis/software/$(PKG)/$(PKG)$(subst .,,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.debian.org/debian/pool/main/d/$(PKG)/$(PKG)_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_DEPS     := gcc openssl tiff libpng libxml2 zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://dicom.offis.de/dcmtk.php.en' | \
    $(SED) -n 's,.*/dcmtk-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)'/config && autoconf -f
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-openssl \
        --with-libtiff \
        --with-libpng \
        --with-libxml \
        --with-libxmlinc='$(PREFIX)/$(TARGET)' \
        --with-zlib \
        --without-libwrap \
        CXX='$(TARGET)-g++' \
        RANLIB='$(TARGET)-ranlib' \
        AR='$(TARGET)-ar' \
        ARFLAGS=cru \
        LIBTOOL=$(LIBTOOL) \
        ac_cv_my_c_rightshift_unsigned=no
    $(MAKE) -C '$(1)' -j '$(JOBS)' install-lib
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
