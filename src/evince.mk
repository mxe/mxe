# This file is *NOT* part of MXE.
# See index.html for further information.

PKG             := evince
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 043895af7bbd6f1b57f9ab8778e78cf9c0af5dfcc347eaa94a17bf864c04dc8f
$(PKG)_VERSION  := 3.24.0
$(PKG)_SUBDIR   := evince-$($(PKG)_VERSION)
$(PKG)_FILE     := evince-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/evince/3.24/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtk3 poppler libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnome.org/pub/GNOME/sources/evince/3.24/' | \
    grep 'evince-' | \
    $(SED) -n 's,.*evince-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
	--disable-doxygen \
	--without-libgnome \
	--without-gconf \
	--without-keyring \
	--with-platform=win32 \
	--with-smclient-backend=win32 \
	--disable-help \
	--disable-thumbnailer \
	--disable-nautilus \
	--disable-dbus \
	--disable-gtk-doc \
	--disable-previewer \
	--disable-nls \
	--without-gtk-unix-print \
	--disable-comics \
	--disable-browser-plugin \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(1)/' -j '$(JOBS)' install
endef
