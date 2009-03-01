# ATK
# http://www.gtk.org/

PKG            := atk
$(PKG)_VERSION := 1.24.0
$(PKG)_SUBDIR  := atk-$($(PKG)_VERSION)
$(PKG)_FILE    := atk-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL     := http://ftp.gnome.org/pub/gnome/sources/atk/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc glib gettext

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gtk.org/download-windows.html' | \
    grep 'atk-' | \
    $(SED) -n 's,.*atk-\([1-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    sed 's,DllMain,static _disabled_DllMain,' -i '$(1)/atk/atkobject.c'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-glibtest \
        --disable-gtk-doc
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
