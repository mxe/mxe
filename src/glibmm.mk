# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GLibmm
PKG             := glibmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.28.1
$(PKG)_CHECKSUM := 76cfba52d8fb1e3f46d14c3fea31269deb49e2fc
$(PKG)_SUBDIR   := glibmm-$($(PKG)_VERSION)
$(PKG)_FILE     := glibmm-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gtkmm.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/glibmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libsigc++

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/glibmm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # cross build
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        CXX='$(TARGET)-c++' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        GLIB_COMPILE_SCHEMAS='$(PREFIX)/$(TARGET)/bin/glib-compile-schemas' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)/gio/src' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= MISC_STUFF=
    $(MAKE) -C '$(1)'         -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
