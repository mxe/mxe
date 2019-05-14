# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgdamm
$(PKG)_WEBSITE  := https://launchpad.net/libgdamm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.3
$(PKG)_CHECKSUM := 9e7c04544fb580d8b00216ca191ab863dff73abec0e569159f4aa640f6319881
$(PKG)_SUBDIR   := libgdamm-$($(PKG)_VERSION)
$(PKG)_FILE     := libgdamm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libgdamm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glibmm libgda

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/libgdamm/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    grep -v "^[0-9]\+\.9[0-9]" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        CXX='$(TARGET)-g++' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
