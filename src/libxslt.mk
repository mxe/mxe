# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxslt
$(PKG)_WEBSITE  := https://gitlab.gnome.org/GNOME/libxslt/-/wikis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.35
$(PKG)_CHECKSUM := 8247f33e9a872c6ac859aa45018bc4c4d00b97e2feac9eebc10c93ce1f34dd79
$(PKG)_SUBDIR   := libxslt-$($(PKG)_VERSION)
$(PKG)_FILE     := libxslt-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libxslt/1.1/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgcrypt libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/libxslt/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\([0-9,\.]\+\)<.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-debug \
        --with-libxml-prefix='$(PREFIX)/$(TARGET)' \
        --without-python \
        --without-plugins
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS)
endef
