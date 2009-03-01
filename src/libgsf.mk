# libgsf
# http://ftp.gnome.org/pub/gnome/sources/libgsf/

PKG            := libgsf
$(PKG)_VERSION := 1.14.11
$(PKG)_SUBDIR  := libgsf-$($(PKG)_VERSION)
$(PKG)_FILE    := libgsf-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL     := http://ftp.gnome.org/pub/gnome/sources/libgsf/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc zlib bzip2 glib libxml2

define $(PKG)_UPDATE
    wget -q -O- -U 'mingw_cross_env' 'http://freshmeat.net/projects/libgsf/' | \
    grep 'libgsf-' | \
    $(SED) -n 's,.*libgsf-\([1-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Don't search for intltool
    $(SED) 's,\(INTLTOOL_APPLIED_VERSION\)=.*,\1=0.35.0,' -i '$(1)/configure'
    $(SED) 's,^\(INTLTOOL_UPDATE\)=.*,\1=disabled,' -i '$(1)/configure'
    $(SED) 's,^\(INTLTOOL_MERGE\)=.*,\1=disabled,' -i '$(1)/configure'
    $(SED) 's,^\(INTLTOOL_EXTRACT\)=.*,\1=disabled,' -i '$(1)/configure'
    $(SED) 's,require XML::Parser,,' -i '$(1)/configure'
    # build
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls \
        --disable-gtk-doc \
        --disable-schemas-install \
        --without-python \
        --without-gnome-vfs \
        --without-bonobo \
        --with-zlib \
        --with-bz2 \
        --with-gio \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
