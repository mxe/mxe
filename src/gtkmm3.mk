# This file is part of MXE.
# See index.html for further information.

PKG             := gtkmm3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.14.0
$(PKG)_CHECKSUM := d9f528a62c6ec226fa08287c45c7465b2dce5aae5068e9ac48d30a64a378e48b
$(PKG)_SUBDIR   := gtkmm-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkmm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtkmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc atkmm cairomm gtk3 libsigc++ pangomm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/gtkmm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    grep '^3\.' | \
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
        -W -Wall -Werror -pedantic -std=c++0x \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-gtkmm3.exe' \
        `'$(TARGET)-pkg-config' gtkmm-3.0 --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
