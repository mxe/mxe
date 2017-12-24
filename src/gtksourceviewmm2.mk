# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtksourceviewmm2
$(PKG)_WEBSITE  := https://projects.gnome.org/gtksourceview/
$(PKG)_DESCR    := GtkSourceViewmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.3
$(PKG)_CHECKSUM := 0000df1b582d7be2e412020c5d748f21c0e6e5074c6b2ca8529985e70479375b
$(PKG)_SUBDIR   := gtksourceviewmm-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gtksourceviewmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gtkmm2 gtksourceview

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.gnome.org/cgit/gtksourceviewmm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=gtksourceviewmm-\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '^2\.9[0-9]\.' | \
    grep '^2\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= doc_install='# DISABLED: doc-install.pl'
endef

$(PKG)_BUILD_SHARED =
