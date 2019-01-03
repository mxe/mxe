# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := unzip
$(PKG)_WEBSITE  := https://infozip.sourceforge.io/UnZip.html
$(PKG)_DESCR    := Info-ZIP
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.10b
$(PKG)_CHECKSUM := 6cf44ac86789008d9493896b7816027f6022be24ad90a15d472393902584a5a2
$(PKG)_VERSIONF := $(shell echo $($(PKG)_VERSION) | tr -d .)
$(PKG)_SUBDIR   := $(PKG)$($(PKG)_VERSIONF)
$(PKG)_FILE     := $(PKG)$($(PKG)_VERSIONF).zip
$(PKG)_URL      := $(SOURCEFORGE_MIRROR)/project/infozip/unreleased%20Betas/UnZip%20betas/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib

define $(PKG)_UPDATE
    echo 'NOTE: automatic updates for unzip are disabled.' >&2;
    echo $(unzip_VERSION)
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' -f win32/Makefile.gcc \
        CC=$(TARGET)-gcc \
        RC=$(TARGET)-windres \
        USEZLIB=1 \
        CC_CPU_OPT='-mtune=generic'

    $(INSTALL) '$(1)'/*.exe '$(PREFIX)'/$(TARGET)/bin
endef
