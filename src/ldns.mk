# This file is part of MXE.
# See index.html for further information.

PKG             := ldns
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.17
$(PKG)_CHECKSUM := 8b88e059452118e8949a2752a55ce59bc71fa5bc414103e17f5b6b06f9bcc8cd
$(PKG)_SUBDIR   := ldns-$($(PKG)_VERSION)
$(PKG)_FILE     := ldns-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://nlnetlabs.nl/downloads/ldns/$($(PKG)_FILE)
# $(PKG)_URL_2    := .../$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://nlnetlabs.nl/downloads/' | \
    grep 'ldns-[0-9]' | \
    $(SED) -n 's,.*ldns-\([0-9][^>]*\)\.tar\.gz.*,\1,p' | \
    grep -v 'rc[0-9]' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
	LIBS="`'$(TARGET)-pkg-config' openssl --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

