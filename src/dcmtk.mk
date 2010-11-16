# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# DCMTK
PKG             := dcmtk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.5.4
$(PKG)_CHECKSUM := 169056874947083e68eb941fcd53faaebc862ae5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://dicom.offis.de/dcmtk.php.en
$(PKG)_URL      := ftp://dicom.offis.de/pub/dicom/offis/software/dcmtk/dcmtk$(subst .,,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openssl tiff libpng libxml2 zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://dicom.offis.de/download/dcmtk/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="dcmtk\([0-9]\)\([0-9]\)\([0-9]\)/.*,\1.\2.\3,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
	--with-openssl \
	--with-libtiff \
	--with-libpng \
	--with-libxml \
	--with-libxmlinc='$(PREFIX)/$(TARGET)/include/libxml2' \
	--with-zlib \
	--without-libwrap \
	CXX='$(TARGET)-g++' \
	RANLIB='$(TARGET)-ranlib' \
	AR='$(TARGET)-ar' \
	ARFLAGS=cru
    $(MAKE) -C '$(1)' -j '$(JOBS)' install-lib
endef
