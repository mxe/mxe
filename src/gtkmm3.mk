# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtkmm3
$(PKG)_WEBSITE  := https://www.gtkmm.org/
$(PKG)_DESCR    := GTKMM
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.20.1
$(PKG)_CHECKSUM := 051de1b8756ca6ec61f26264338cfc3060af936fd70bf4558bfe1e115418c612
$(PKG)_SUBDIR   := gtkmm-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkmm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gtkmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc atkmm cairomm gtk3 libsigc++ pangomm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/gtkmm/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    grep '^3\.' | \
    grep -v "^[0-9]\+\.9[0-9]" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= LIBS="`$(TARGET)-pkg-config --libs glibmm-2.4`"
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= doc_install='# DISABLED: doc-install.pl' LIBS="`$(TARGET)-pkg-config --libs glibmm-2.4`"

    '$(TARGET)-g++' \
        -W -Wall -Wno-deprecated-declarations -Werror -pedantic -std=c++11 \
        -Wno-error=deprecated \
        $($(PKG)_EXTRA_WARNINGS) \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gtkmm3.exe' \
        `'$(TARGET)-pkg-config' gtkmm-3.0 --cflags --libs`
endef
