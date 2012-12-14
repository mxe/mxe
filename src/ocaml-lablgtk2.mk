# This file is part of mingw-cross-env.
# See doc/index.html for further information.

PKG             := ocaml-lablgtk2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3dec411a410fbb38d6e2e5a43a4ebfb2e407e7e6
$(PKG)_SUBDIR   := lablgtk-$($(PKG)_VERSION)
$(PKG)_FILE     := lablgtk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://forge.ocamlcore.org/frs/download.php/979/$($(PKG)_FILE)
$(PKG)_DEPS     := ocaml-findlib libglade gtkglarea ocaml-lablgl gtk2

define $(PKG)_UPDATE
    wget -q -O- 'http://forge.ocamlcore.org/frs/?group_id=220' | \
    sed -n 's,.*lablgtk-\(2[^>]*\)\.tar.*,\1,ip' | \
    sort | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        --host $(TARGET) \
        --build "`config.guess`" \
        --prefix $(PREFIX)/$(TARGET)
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' lablgtkopt
    $(MAKE) -C '$(1)/src' -j 1 install

    # test
    cp '$(2).ml' '$(1)/test.ml'
    cd '$(1)' && '$(TARGET)-ocamlfind' opt -package lablgtk2.gl -linkpkg test.ml
endef
