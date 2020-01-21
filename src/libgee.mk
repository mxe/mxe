# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgee
$(PKG)_WEBSITE  := https://wiki.gnome.org/Projects/Libgee
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.20.1
$(PKG)_CHECKSUM := bb2802d29a518e8c6d2992884691f06ccfcc25792a5686178575c7111fea4630
$(PKG)_SUBDIR   := libgee-$($(PKG)_VERSION)
$(PKG)_FILE     := libgee-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libgee/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/libgee/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        MAKE=$(MAKE)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libgee.exe' \
        `'$(TARGET)-pkg-config' gee-0.8 gio-2.0 --cflags --libs`
endef
