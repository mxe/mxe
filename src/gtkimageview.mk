# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtkimageview
$(PKG)_WEBSITE  := http://trac.bjourne.webfactional.com/
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

define $(PKG)_UPDATE_DISABLED
    $(WGET) -q -O- "http://trac.bjourne.webfactional.com/chrome/common/releases/?C=M;O=D" | \
    grep -i '<a href="gtkimageview.*tar' | \
    $(SED) -n 's,.*gtkimageview-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_UPDATE
    echo 'TODO: gtkimageview is dead' >&2;
    echo '$(gtkimageview_VERSION)'
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-gtk-doc \
        GLIB_GENMARSHAL='$(PREFIX)/$(TARGET)/bin/glib-genmarshal' \
        GLIB_MKENUMS='$(PREFIX)/$(TARGET)/bin/glib-mkenums' \
        CFLAGS='-Wno-error=deprecated-declarations -std=c99'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gtkimageview.exe' \
        `'$(TARGET)-pkg-config' gtkimageview --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
