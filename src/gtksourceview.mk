# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GTKSourceView
PKG             := gtksourceview
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.5
$(PKG)_CHECKSUM := 5081dc7a081954d0af73852c22e874a746bda30e
$(PKG)_SUBDIR   := gtksourceview-$($(PKG)_VERSION)
$(PKG)_FILE     := gtksourceview-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://projects.gnome.org/gtksourceview/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtksourceview/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtk2 libxml2

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/gtksourceview/refs/tags' | \
    $(SED) -n 's,.*>GTKSOURCEVIEW_\([0-9]\+_[0-9]*[02468]_[^<]*\)<.*,\1,p' | \
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
