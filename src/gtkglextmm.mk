# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtkglextmm
$(PKG)_WEBSITE  := https://gtkglext.sourceforge.io/
$(PKG)_DESCR    := GtkGLExtmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 8f499c1f95678c56cce908c10bf2c1d0f2267b87e0c480385fa4b128c75bdf7b
$(PKG)_SUBDIR   := gtkglextmm-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkglextmm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/gtkglext/gtkglextmm/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gtkglext gtkmm2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/Archive/gtkglextmm/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        INFO_DEPS=

    '$(TARGET)-g++' \
        -W -Wall -Werror -Wno-error=deprecated-declarations -pedantic -std=c++0x \
        -Wno-error=deprecated \
        $($(PKG)_EXTRA_WARNINGS) \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gtkglextmm.exe' \
        `'$(TARGET)-pkg-config' gtkglextmm-1.2 --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
