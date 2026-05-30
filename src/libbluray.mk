# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libbluray
$(PKG)_WEBSITE  := https://www.videolan.org/developers/libbluray.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.1
$(PKG)_CHECKSUM := 76b5dc40097f28dca4ebb009c98ed51321b2927453f75cc72cf74acd09b9f449
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := https://download.videolan.org/pub/videolan/libbluray/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper freetype libudfread libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.videolan.org/pub/videolan/libbluray/' | \
    $(SED) -n 's,<a href="\([0-9][^<]*\)/".*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Denable_examples=false \
        -Dbdj_jar=disabled \
        -Dfreetype=enabled \
        -Dlibxml2=enabled \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror \
        '$(1)/src/examples/sound_dump.c' -o '$(PREFIX)/$(TARGET)/bin/test-libbluray.exe' \
        `'$(TARGET)-pkg-config' libbluray --cflags --libs` \
        -I '$(PREFIX)/$(TARGET)/include/libbluray'
endef
