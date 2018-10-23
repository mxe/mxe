# This file is part of MXE.
# See index.html for further information.

PKG             := libxdf
$(PKG)_WEBSITE  := 
$(PKG)_DESCR    := libxdf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.98
$(PKG)_CHECKSUM := 0c3791474f3658fca54e62b16db9e6d82b3eb68e92b77fd37d349263d3fe1e75
$(PKG)_SUBDIR   := libxdf-0.98
$(PKG)_FILE     := libxdf-0.98.zip
$(PKG)_URL      := https://github.com/Yida-Lin/libxdf/archive/v0.98.zip
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
#    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
#    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

	mkdir '$(1)/native_build' 
	cd '$(1)/native_build' && cmake \
		-DCMAKE_BUILD_TYPE="Release" \
		'$(1)'

	$(MAKE) -C '$(1)/native_build'
    
	$(INSTALL) '$(1)/xdf.h'    '$(PREFIX)/$(TARGET)/include/'
	#$(INSTALL) '$(1)/native_build/'libxdf.so' '$(PREFIX)/$(TARGET)/lib/'
	$(INSTALL) '$(1)/native_build/libxdf.a' '$(PREFIX)/$(TARGET)/lib/'

endef

