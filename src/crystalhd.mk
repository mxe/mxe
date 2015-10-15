# This file is part of MXE.
# See index.html for further information.

PKG             := crystalhd
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := 818d72fdbebcfc0a449d9e39153370c80325f2490798f82f1ed98c6bb60bc18c
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := crystalhd_lgpl_includes_v$($(PKG)_VERSION).zip
$(PKG)_URL      := http://www.broadcom.com/docs/support/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

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
