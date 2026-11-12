# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtkimageview
$(PKG)_WEBSITE  := https://web.archive.org/web/20130517010338/trac.bjourne.webfactional.com/
$(PKG)_DESCR    := GtkImageView
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.4
$(PKG)_CHECKSUM := 4c681d38d127ee3950a29bce9aa7aa8a2abe3b4d915f7a0c88e526999c1a46f2
$(PKG)_SUBDIR   := gtkimageview-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkimageview-$($(PKG)_VERSION).tar.gz
# gtkimageview download server is dead.
# $(PKG)_URL    := http://trac.bjourne.webfactional.com/chrome/common/releases/$($(PKG)_FILE)
$(PKG)_URL      := https://distfiles.macports.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gtk2

define $(PKG)_UPDATE
    echo 'NOTE: gtkimageview is abandoned upstream; automatic updates are disabled.' >&2;
    echo $(gtkimageview_VERSION)
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-gtk-doc \
        GLIB_GENMARSHAL='$(PREFIX)/$(TARGET)/bin/glib-genmarshal' \
        GLIB_MKENUMS='$(PREFIX)/$(TARGET)/bin/glib-mkenums' \
        CFLAGS='-O2 -g -std=c99'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gtkimageview.exe' \
        `'$(TARGET)-pkg-config' gtkimageview --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
