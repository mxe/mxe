# This file is part of MXE.
# See index.html for further information.

PKG             := ocaml-cairo
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := d5835620bea005d5d5239f889b10a922fda2520b
$(PKG)_SUBDIR   := cairo-ocaml-$($(PKG)_VERSION)
$(PKG)_FILE     := cairo-ocaml_$($(PKG)_VERSION).orig.tar.gz
# URL http://cgit.freedesktop.org/cairo-ocaml/snapshot/$($(PKG)_FILE) gives a different checksum at each download, so I use the debian version.
$(PKG)_URL      := http://ftp.de.debian.org/debian/pool/main/c/cairo-ocaml/$($(PKG)_FILE)
$(PKG)_DEPS     := ocaml-core ocaml-findlib ocaml-lablgtk2

define $(PKG)_UPDATE
	wget -q -O- 'http://ftp.de.debian.org/debian/pool/main/c/cairo-ocaml' | \
	$(SED) -n 's,.*cairo-ocaml-\([0-9][^>]*\)\.orig\.tar.*,\1,ip' | \
	head -1
endef

define $(PKG)_BUILD
	cd '$(1)' && aclocal -I support
	cd '$(1)' && autoconf
	cd '$(1)' && ./configure \
		--host $(TARGET) \
		--prefix='$(PREFIX)/$(TARGET)'
	cd '$(1)' && make install
	cd '$(1)' && cp -f META $(PREFIX)/$(TARGET)/lib/ocaml/cairo/
	# test
	cp '$(2).ml' '$(1)/test.ml'
	cd '$(1)' && '$(TARGET)-ocamlfind' opt -linkpkg \
	  -package lablgtk2.init \
	  -package cairo.lablgtk2 \
	  test.ml
endef
