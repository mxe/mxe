# This file is part of MXE.
# See index.html for further information.

PKG             := libxdf
$(PKG)_WEBSITE  :=
$(PKG)_DESCR    := libxdf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.99.8
$(PKG)_CHECKSUM := 60098abed9a7ed4b8829b8302dbecc1abd14ca6c14e7d2dc5efbb727722834b3
$(PKG)_SUBDIR   := libxdf-$($(PKG)_VERSION)
$(PKG)_FILE     := libxdf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/xdf-modules/libxdf/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
#    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
#    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
	mkdir '$(1)/native_build'
	cd '$(1)/native_build' && $(TARGET)-cmake \
		-DCMAKE_BUILD_TYPE="Release" \
		-DSHARED_LIBS=$(if $(BUILD_STATIC),OFF,ON) \
		'$(1)'

	$(MAKE) -C '$(1)/native_build'

	$(INSTALL) '$(1)/xdf.h'    '$(PREFIX)/$(TARGET)/include/'
	$(INSTALL) '$(1)'/native_build/libxdf.$(if $(BUILD_STATIC),"a","dll*") '$(PREFIX)/$(TARGET)/lib/'
endef
