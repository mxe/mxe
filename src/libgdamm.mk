# This file is part of MXE.
# See index.html for further information.

PKG             := libgdamm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.3
$(PKG)_CHECKSUM := f6126d7b46720e3ea4f3d49e03add2e52da233be
$(PKG)_SUBDIR   := libgdamm-$($(PKG)_VERSION)
$(PKG)_FILE     := libgdamm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libgdamm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgda glibmm

define $(PKG)_UPDATE
    echo 'TODO: Updates for package libgdamm need to be fixed.' >&2;
    echo $(libgdamm_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        CXX='$(TARGET)-c++' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
