# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := py-asn1ate
$(PKG)_WEBSITE  := https://github.com/kimgr/asn1ate
$(PKG)_DESCR    := ASN.1 translation library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2df1ab8
$(PKG)_CHECKSUM := e923af7e91770bfa5236e06a4e18be4b3014126c53c4562684317e5d8d3600df
$(PKG)_GH_CONF  := kimgr/asn1ate/master
$(PKG)_DEPS     := python-conf py-pyparsing
$(PKG)_TARGETS  := $(BUILD)

#asn1ate required for quick-der
#pyasn1 only required for tests

define $(PKG)_BUILD
    # install python library
    cd '$(SOURCE_DIR)' && python setup.py install \
        --prefix='$(PREFIX)/$(TARGET)'
endef
