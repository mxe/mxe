# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xmlwrapp
$(PKG)_WEBSITE  := https://sourceforge.net/projects/xmlwrapp/
$(PKG)_GH_CONF  := vslavik/xmlwrapp/releases/latest,v
$(PKG)_VERSION  := 0.9.0
$(PKG)_CHECKSUM := 4bd6d24f2039f9f1394ba400681a41690f53fb73cfd7135507c8918feec9f11c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_DEPS     := cc boost libxml2 libxslt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/xmlwrapp/files/xmlwrapp/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        $(MXE_CONFIGURE_OPTS) \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=
endef