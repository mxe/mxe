# This file is part of MXE.
# See index.html for further information.

PKG             := libnice
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.13
$(PKG)_CHECKSUM := 61112d9f3be933a827c8365f20551563953af6718057928f51f487bfe88419e1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://nice.freedesktop.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib

define $(PKG)_UPDATE
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        GLIB_COMPILE_SCHEMAS='$(PREFIX)/$(TARGET)/bin/glib-compile-schemas' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)'         -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(TARGET)-gcc \
        '$(1)/examples/simple-example.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config nice --cflags --libs`
endef
