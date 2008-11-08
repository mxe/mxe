# pkg-config
# http://pkg-config.freedesktop.org/

PKG            := pkg_config
$(PKG)_VERSION := 0.23
$(PKG)_SUBDIR  := pkg-config-$($(PKG)_VERSION)
$(PKG)_FILE    := pkg-config-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://pkgconfig.freedesktop.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS    :=

define $(PKG)_UPDATE
    wget -q -O- 'http://pkgconfig.freedesktop.org/' | \
    $(SED) -n 's,.*current release of pkg-config is version \([0-9][^ ]*\) and.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(2)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(2)' -j '$(JOBS)' install
    mkdir -p '$(PREFIX)/bin'
    rm -f '$(PREFIX)/bin/$(TARGET)-pkg-config'
    ln -s '../$(TARGET)/bin/pkg-config' '$(PREFIX)/bin/$(TARGET)-pkg-config'
endef
