# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ocaml-cairo
$(PKG)_WEBSITE  := https://cairographics.org/cairo-ocaml/
$(PKG)_DESCR    := cairo-ocaml
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 4beae96acfc13dbb8b0a798a0664380429c6a94357e7dc5747d76599deabdfc7
$(PKG)_SUBDIR   := cairo-ocaml-$($(PKG)_VERSION)
$(PKG)_FILE     := cairo-ocaml_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_URL      := https://debian.inf.tu-dresden.de/debian/pool/main/c/cairo-ocaml/$($(PKG)_FILE)
$(PKG)_DEPS     := cc ocaml-core ocaml-findlib ocaml-lablgtk2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://debian.inf.tu-dresden.de/debian/pool/main/c/cairo-ocaml/?C=M;O=D' | \
    $(SED) -n 's,.*cairo-ocaml_\([0-9][^>]*\)\.orig\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -I support
    cd '$(1)' && ./configure \
        --host $(TARGET) \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
    cd '$(1)' && cp -f META $(PREFIX)/$(TARGET)/lib/ocaml/cairo/

    # test
    '$(TARGET)-ocamlfind' opt -linkpkg \
        -package lablgtk2.auto-init \
        -package cairo.lablgtk2 \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        < '$(TEST_FILE)'
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
