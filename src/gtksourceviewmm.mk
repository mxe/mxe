# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GtkSourceViewmm
PKG             := gtksourceviewmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.1
$(PKG)_CHECKSUM := 7f6fb046427054d85c791a4b1fc0f742a3313c8a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://projects.gnome.org/gtksourceview/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtksourceviewmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtksourceview

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/cgit/gtksourceviewmm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=gtksourceviewmm-\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
