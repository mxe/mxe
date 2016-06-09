# This file is part of MXE.
# See index.html for further information.

PKG             := quick-der
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1-RC5
$(PKG)_CHECKSUM := 80165d74d1634aff4fde93531a51c3ce316b6cb1302d8198c80030b183fb9b22
$(PKG)_SUBDIR   := $(PKG)-version-$($(PKG)_VERSION)
# $(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_FILE     := version-$($(PKG)_VERSION).tar.gz
# $(PKG)_URL      := https://github.com/vanrein/$($(PKG)_FILE)
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
	HOSTCC='$(BUILD_CC)'

define $(PKG)_BUILD
    # cd '$(1)' && ./configure \
    #     $(MXE_CONFIGURE_OPTS) \
    #     --disable-threads \
    #     --disable-nls
    echo $(MAKE) PREFIX=$(PREFIX)/$(TARGET) -C '$(1)' -j '$(JOBS)' all install
endef
