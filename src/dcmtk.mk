# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := dcmtk
$(PKG)_WEBSITE  := https://dicom.offis.de/dcmtk.php.en
$(PKG)_DESCR    := DCMTK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.0
$(PKG)_CHECKSUM := cfc509701122adfa359f1ee160e943c1548c7696b607dbb646c5a06f015ed33a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://dicom.offis.de/download/$(PKG)/$(PKG)$(subst .,,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_URL_2    := https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/$(PKG)/$(PKG)_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_DEPS     := cc libpng libxml2 openssl tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://dicom.offis.de/dcmtk.php.en' | \
    $(SED) -n 's,.*/dcmtk-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

# openssl 1.1 breaks build and newer version switched to cmake with
# build that requires wine - disable openssl for now
# see plugins/examples/openssl1.0 for example of re-enabling support
define $(PKG)_BUILD
    cd '$(1)'/config && autoconf -f
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-openssl \
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
        ac_cv_my_c_rightshift_unsigned=no \
        $($(PKG)_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install-lib
endef

$(PKG)_BUILD_SHARED =
