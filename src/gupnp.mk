PKG             := gupnp
$(PKG)_WEBSITE  := https://download.gnome.org/
$(PKG)_DESCR    := Core UPnP API built on top of gssdp.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.4
$(PKG)_CHECKSUM := 8b0992650c6ef8566d2d0c9198c8a669106dc2c73aa908fcc4a4d043a8c0b544
$(PKG)_SUBDIR   := gupnp-$($(PKG)_VERSION)
$(PKG)_FILE     := gupnp-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gupnp/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gssdp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.gnome.org/browse/gupnp/refs/tags' | \
    $(SED) -n "s,.*gupnp-\([0-9]\+\.[0-9]*[02468]\.[^']*\)\.tar.*,\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
	$(subst docdir$(comma),,$(MXE_CONFIGURE_OPTS))
    $(MAKE) -C '$(1)'
    $(MAKE) -C '$(1)' install
endef
