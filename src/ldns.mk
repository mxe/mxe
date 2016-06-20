# This file is part of MXE.
# See index.html for further information.

PKG             := ldns
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.15
$(PKG)_CHECKSUM := 0e9d3e8f52098a01780f1f747a1d382b8983fdb50c84603599e7b0613f51749b
$(PKG)_SUBDIR   := ldns-$($(PKG)_VERSION)
$(PKG)_FILE     := ldns-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://nlnetlabs.nl/downloads/$($(PKG)_FILE)
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

