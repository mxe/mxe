# This file is part of MXE.
# See index.html for further information.

PKG             := ocaml-cairo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := d5835620bea005d5d5239f889b10a922fda2520b
$(PKG)_SUBDIR   := cairo-ocaml-$($(PKG)_VERSION)
$(PKG)_FILE     := cairo-ocaml_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_URL      := http://ftp.de.debian.org/debian/pool/main/c/cairo-ocaml/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ocaml-core ocaml-findlib ocaml-lablgtk2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.de.debian.org/debian/pool/main/c/cairo-ocaml/?C=M;O=D' | \
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
        < '$(2).ml'
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
