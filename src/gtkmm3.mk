# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtkmm3
$(PKG)_WEBSITE  := https://www.gtkmm.org/
$(PKG)_DESCR    := GTKMM
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.24.11
$(PKG)_CHECKSUM := 19e383c82d5dd89db275e00b82864e90414d4c3fb3d100b2f996bcc2338a4cc7
$(PKG)_SUBDIR   := gtkmm-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkmm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gtkmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper atkmm cairomm gtk3 libsigc++ pangomm

$(PKG)_EXTRA_WARNINGS := \
    -Wno-cast-function-type \
    -Wno-deprecated \
    -Wno-deprecated-declarations

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/gtkmm/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    grep '^3\.' | \
    grep -v "^[0-9]\+\.9[0-9]" | \
    head -1
endef

define $(PKG)_BUILD
    # Meson configure, with additional options for Gtkmm
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dbuild-tests=false \
        -Dbuild-demos=false \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    DESTDIR="/" \
        '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic -std=c++11 \
        $($(PKG)_EXTRA_WARNINGS) \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gtkmm3.exe' \
        `'$(TARGET)-pkg-config' gtkmm-3.0 --cflags --libs`
endef
