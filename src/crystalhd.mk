# This file is part of MXE.
# See index.html for further information.

PKG             := crystalhd
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := 2ee046b1a20485abb750244d4c71f733673496f7
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := crystalhd_lgpl_includes_v1.zip
$(PKG)_URL      := http://www.broadcom.com/docs/support/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo "TODO: crystalhd update script" >&2
    echo $(crystalhd_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(PREFIX)/$(TARGET)/include/libcrystalhd'
    cd '$(1)' && cp *.h '$(PREFIX)/$(TARGET)/include/libcrystalhd'
endef
