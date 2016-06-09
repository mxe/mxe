# This file is part of MXE.
# See index.html for further information.

PKG             := asn2quickder
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6-RC1
$(PKG)_CHECKSUM := b1d3145ddb159cf76495157cb25e2c5e047b3809bf7fbffa95bdea56154d74fa
$(PKG)_SUBDIR   := $(PKG)-version-$($(PKG)_VERSION)
# $(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_FILE     := version-$($(PKG)_VERSION).tar.gz
# $(PKG)_URL      := https://github.com/vanrein/$($(PKG)_FILE)
$(PKG)_URL	:= https://github.com/vanrein/asn2quickder/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/vanrein/asn2quickder/tags' | \
    grep '<a href="/vanrein/asn2quickder/archive/' | \
    $(SED) -n 's,.*href="/vanrein/asn2quickder/archive/version-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

$(PKG)_MAKE_OPTS = \
	PREFIX='$(PREFIX)/$(BUILD)' \
	CROSS_SUFFIX='$(TARGET)-' \
	CC='$(TARGET)-gcc' \
	AR='$(TARGET)-ar' \
	HOSTCC='$(BUILD_CC)'

define $(PKG)_BUILD
    # cd '$(1)' && ./configure \
    #     $(MXE_CONFIGURE_OPTS) \
    #     --disable-threads \
    #     --disable-nls
    $(MAKE) PREFIX=$(PREFIX)/$(TARGET) -C '$(1)' -j '$(JOBS)' all install
endef
