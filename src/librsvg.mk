# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := librsvg
$(PKG)_WEBSITE  := https://wiki.gnome.org/Projects/LibRsvg
$(PKG)_VERSION  := 2.46.0
$(PKG)_CHECKSUM := 96c81e52cb81450f3b2e915e6409fd7d1e3c01e4661974b3a98c09a7c45743d1
$(PKG)_SUBDIR   := librsvg-$($(PKG)_VERSION)
$(PKG)_FILE     := librsvg-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/librsvg/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cairo gdk-pixbuf glib libcroco libgsf pango $(BUILD)~rustc rust-std

ifneq (, $(findstring darwin,$(BUILD)))
    BUILD_TRIPLET = $(firstword $(call split,-,$(BUILD)))-apple-darwin
else
    ifneq (, $(findstring ibm-linux,$(BUILD)))
        BUILD_TRIPLET = $(firstword $(call split,-,$(BUILD)))-unknown-linux-gnu
    else
        BUILD_TRIPLET = $(BUILD)
    endif
endif

TARGET_TRIPLET          = $(firstword $(call split,-,$(TARGET)))-pc-windows-gnu

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/librsvg/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cat '$(PREFIX)/$(TARGET)/.cargo/config' >> '$(SOURCE_DIR)/.cargo/config'
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        --build=$(BUILD_TRIPLET) \
        --host=$(TARGET) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-gtk-doc \
        $(if $(BUILD_STATIC), \
        --enable-static --disable-shared --disable-pixbuf-loader, \
        --disable-static --enable-shared) \
        --enable-gtk-doc=no \
        --enable-introspection=no \
        RUST_TARGET=$(TARGET_TRIPLET) \
        RUSTC='$(PREFIX)/$(BUILD)/bin/rustc' \
        CARGO='$(PREFIX)/$(BUILD)/bin/cargo' \
        LIBS='-luserenv -lws2_32 -liphlpapi -ldnsapi'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -mwindows -W -Wall -Werror -Wno-error=deprecated-declarations \
        -std=c99 -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-librsvg.exe' \
        `'$(TARGET)-pkg-config' librsvg-2.0 --cflags --libs` -liphlpapi -ldnsapi
endef
