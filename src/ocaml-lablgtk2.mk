# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ocaml-lablgtk2
$(PKG)_WEBSITE  := https://forge.ocamlcore.org/
$(PKG)_DESCR    := lablgtk2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.16.0
$(PKG)_CHECKSUM := a0ea9752eb257dadcfc2914408fff339d4c34357802f02c63329dd41b777de2f
$(PKG)_SUBDIR   := lablgtk-$($(PKG)_VERSION)
$(PKG)_FILE     := lablgtk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://forge.ocamlcore.org/frs/download.php/979/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gtk2 gtkglarea gtksourceview libglade ocaml-findlib ocaml-lablgl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://forge.ocamlcore.org/frs/?group_id=220' | \
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
        < '$(TEST_FILE)'
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
