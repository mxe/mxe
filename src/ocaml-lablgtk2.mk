# This file is part of MXE.
# See index.html for further information.

PKG             := ocaml-lablgtk2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.16.0
$(PKG)_CHECKSUM := 3dec411a410fbb38d6e2e5a43a4ebfb2e407e7e6
$(PKG)_SUBDIR   := lablgtk-$($(PKG)_VERSION)
$(PKG)_FILE     := lablgtk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://forge.ocamlcore.org/frs/download.php/979/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ocaml-findlib libglade gtkglarea ocaml-lablgl gtk2 gtksourceview

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://forge.ocamlcore.org/frs/?group_id=220' | \
    $(SED) -n 's,.*lablgtk-\(2[^>]*\)\.tar.*,\1,ip' | \
    $(SORT) | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -I'$(PREFIX)/$(TARGET)/share/aclocal'
    cd '$(1)' && ./configure \
        --host $(TARGET) \
        --build "`config.guess`" \
        --prefix $(PREFIX)/$(TARGET)
    $(MAKE) -C '$(1)/src' -j 1 lablgtkopt
    $(MAKE) -C '$(1)/src' -j 1 install

    # test
    '$(TARGET)-ocamlfind' opt -linkpkg \
        -package lablgtk2.gl \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        < '$(2).ml'
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
