# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := zip
$(PKG)_WEBSITE  := https://infozip.sourceforge.io/Zip.html
$(PKG)_DESCR    := Info-ZIP
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0
$(PKG)_CHECKSUM := f0e8bb1f9b7eb0b01285495a2699df3a4b766784c1765a8f1aeedf63c0806369
$(PKG)_VERSIONF := $(shell echo $($(PKG)_VERSION) | tr -d .)
$(PKG)_SUBDIR   := $(PKG)$($(PKG)_VERSIONF)
$(PKG)_FILE     := $(PKG)$($(PKG)_VERSIONF).tar.gz
$(PKG)_URL      := $(SOURCEFORGE_MIRROR)/project/infozip/Zip%203.x%20%28latest%29/$($(PKG)_VERSION)/$($(PKG)_FILE)

$(PKG)_DEPS     := cc zlib

define $(PKG)_UPDATE
    echo 'NOTE: automatic updates for zip are disabled.' >&2;
    echo $(zip_VERSION)
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' -f win32/makefile.gcc \
        CC=$(TARGET)-gcc \
        RC=$(TARGET)-windres \
        USEZLIB=1

    $(INSTALL) '$(1)'/*.exe '$(PREFIX)'/$(TARGET)/bin
endef
