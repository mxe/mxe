# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xmlwrapp
$(PKG)_WEBSITE  := https://vslavik.github.io/xmlwrapp/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.1
$(PKG)_CHECKSUM := 1c39f5602ade48087eaa1f5396a05375e8379e9e05638fcf9ac00fbadb1d30c8
$(PKG)_GH_CONF  := vslavik/xmlwrapp/releases,v,,,,.tar.xz
$(PKG)_DEPS     := cc libxml2 libxslt

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=
endef

$(PKG)_BUILD_SHARED =
