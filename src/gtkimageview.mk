# This file is part of MXE.
# See index.html for further information.

PKG             := gtkimageview
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.4
$(PKG)_CHECKSUM := a6c78744ba98441bca28c9d27bf89245517940db
$(PKG)_SUBDIR   := gtkimageview-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkimageview-$($(PKG)_VERSION).tar.gz
# gtkimageview download server is dead.
# $(PKG)_URL    := http://trac.bjourne.webfactional.com/chrome/common/releases/$($(PKG)_FILE)
$(PKG)_URL      := https://distfiles.macports.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtk2

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
        GLIB_MKENUMS='$(PREFIX)/$(TARGET)/bin/glib-mkenums'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gtkimageview.exe' \
        `'$(TARGET)-pkg-config' gtkimageview --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
