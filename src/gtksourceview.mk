# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtksourceview
$(PKG)_WEBSITE  := https://projects.gnome.org/gtksourceview/
$(PKG)_DESCR    := GTKSourceView
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.5
$(PKG)_CHECKSUM := c585773743b1df8a04b1be7f7d90eecdf22681490d6810be54c81a7ae152191e
$(PKG)_SUBDIR   := gtksourceview-$($(PKG)_VERSION)
$(PKG)_FILE     := gtksourceview-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://download.gnome.org/sources/gtksourceview/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gtk2 libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.gnome.org/browse/gtksourceview/refs/tags' | \
    $(SED) -n 's,.*>GTKSOURCEVIEW_\([0-9]\+_[0-9]*[02468]_[0-9_]\+\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    grep -v '^2\.9[0-9]\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-gtk-doc \
        GLIB_GENMARSHAL='$(PREFIX)/$(TARGET)/bin/glib-genmarshal' \
        GLIB_MKENUMS='$(PREFIX)/$(TARGET)/bin/glib-mkenums'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
