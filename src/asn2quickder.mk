# This file is part of MXE.
# See index.html for further information.

PKG             := asn2quickder
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.6-RC2
$(PKG)_CHECKSUM := 0d92fdec9ed6f7f12e1994196e46c73e0721ff560eebde59ca8f7ef21fd03068
$(PKG)_SUBDIR   := $(PKG)-version-$($(PKG)_VERSION)
$(PKG)_FILE     := version-$($(PKG)_VERSION).tar.gz
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
    $(MAKE) PREFIX='$(PREFIX)/$(TARGET)' -C '$(1)' -j '$(JOBS)' all install $($(PKG)_MAKE_OPTS)
endef
