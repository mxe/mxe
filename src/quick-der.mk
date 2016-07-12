# This file is part of MXE.
# See index.html for further information.

PKG             := quick-der
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1-RC12
$(PKG)_CHECKSUM := f644e8f97ba2a3370f876f84c82002fc5ef3a465ddf1e13290a5b08b98a8dfea
$(PKG)_SUBDIR   := $(PKG)-version-$($(PKG)_VERSION)
$(PKG)_FILE     := version-$($(PKG)_VERSION).tar.gz
$(PKG)_URL	:= https://github.com/vanrein/quick-der/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc asn2quickder

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/vanrein/quick-der/tags' | \
    grep '<a href="/vanrein/quick-der/archive/' | \
    $(SED) -n 's,.*href="/vanrein/quick-der/archive/version-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

$(PKG)_MAKE_OPTS = \
	PREFIX='$(PREFIX)/$(TARGET)' \
	CROSS_SUFFIX='$(TARGET)-' \
	CC='$(TARGET)-gcc' \
	AR='$(TARGET)-ar' \
	ASN2QUICKDER_CMD='$(PREFIX)/$(BUILD)/bin/asn2quickder' \
	HOSTCC='$(BUILD_CC)' \
    WINVER=0x0600 \
	EXTRALIBS='-lmsvcrt'

define $(PKG)_BUILD
    $(MAKE) PREFIX='$(PREFIX)/$(TARGET)' -C '$(1)' -j '$(JOBS)' all install $($(PKG)_MAKE_OPTS) 
endef
