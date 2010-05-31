# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GTKSourceView
PKG             := gtksourceview
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.3
$(PKG)_CHECKSUM := 318a495315b1b6e67d7a5ef2ea68060cb68b511a
$(PKG)_SUBDIR   := gtksourceview-$($(PKG)_VERSION)
$(PKG)_FILE     := gtksourceview-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://projects.gnome.org/gtksourceview/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtksourceview/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtk libxml2 gettext

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/gtksourceview/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=GTKSOURCEVIEW_\\([0-9]*_[0-9]*[02468]_[^<]*\\)'.*,\\1,p" | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-gtk-doc \
        --enable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
