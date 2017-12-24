# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := crystalhd
$(PKG)_WEBSITE  := https://www.broadcom.com/support/crystal_hd/
$(PKG)_DESCR    := Broadcom Crystal HD Headers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := 818d72fdbebcfc0a449d9e39153370c80325f2490798f82f1ed98c6bb60bc18c
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := crystalhd_lgpl_includes_v$($(PKG)_VERSION).zip
$(PKG)_URL      := https://docs.broadcom.com/docs-and-downloads/docs/support/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    echo "TODO: crystalhd update script" >&2;
    echo $(crystalhd_VERSION)
endef

define $(PKG)_BUILD
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/libcrystalhd'
    for f in "$(1)/*.h"; do \
        $(INSTALL) -m0644 $$f '$(PREFIX)/$(TARGET)/include/libcrystalhd/'; \
    done
endef
