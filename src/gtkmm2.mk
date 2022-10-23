# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtkmm2
$(PKG)_WEBSITE  := https://www.gtkmm.org/
$(PKG)_DESCR    := GTKMM
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.24.5
$(PKG)_CHECKSUM := 0680a53b7bf90b4e4bf444d1d89e6df41c777e0bacc96e9c09fc4dd2f5fe6b72
$(PKG)_SUBDIR   := gtkmm-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkmm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gtkmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc atkmm cairomm gtk2 libsigc++ pangomm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/gtkmm/-/tags?sort=updated_desc&search=^2.' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= doc_install='# DISABLED: doc-install.pl'

    '$(TARGET)-g++' \
        -W -Wall -Wno-deprecated-declarations -Werror -pedantic -std=c++11 \
        -Wno-error=deprecated \
        $($(PKG)_EXTRA_WARNINGS) \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gtkmm2.exe' \
        `'$(TARGET)-pkg-config' gtkmm-2.4 --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
