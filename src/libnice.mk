# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libnice
$(PKG)_WEBSITE  := https://libnice.freedesktop.org
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.16
$(PKG)_CHECKSUM := 06b678066f94dde595a4291588ed27acd085ee73775b8c4e8399e28c01eeefdf
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://libnice.freedesktop.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib gnutls

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cgit.freedesktop.org/libnice/libnice/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*\.[^<]*\)<.*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        PKG_CONFIG='$(TARGET)-pkg-config' \
        GLIB_COMPILE_SCHEMAS='$(PREFIX)/$(TARGET)/bin/glib-compile-schemas' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS)
    $(TARGET)-gcc \
        '$(SOURCE_DIR)/examples/simple-example.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config nice --cflags --libs`
endef
