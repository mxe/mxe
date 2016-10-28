# This file is part of MXE.
# See index.html for further information.

PKG             := quick-der
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0-RC2
$(PKG)_CHECKSUM := 8afea3b5374b302d9183623aab84ab783c194a3ca9d29152d5d6e82d65b4cf75
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
