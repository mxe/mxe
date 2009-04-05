# pkg-config

PKG             := pkg_config
$(PKG)_VERSION  := 0.23
$(PKG)_CHECKSUM := b59dddd6b5320bd74c0f74b3339618a327096b2a
$(PKG)_SUBDIR   := pkg-config-$($(PKG)_VERSION)
$(PKG)_FILE     := pkg-config-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://pkg-config.freedesktop.org/
$(PKG)_URL      := http://pkgconfig.freedesktop.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'http://pkgconfig.freedesktop.org/' | \
    $(SED) -n 's,.*current release of pkg-config is version \([0-9][^ ]*\) and.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
    $(INSTALL) -d                       '$(PREFIX)/bin'
    rm -f                               '$(PREFIX)/bin/$(TARGET)-pkg-config'
    ln -s '../$(TARGET)/bin/pkg-config' '$(PREFIX)/bin/$(TARGET)-pkg-config'
endef
