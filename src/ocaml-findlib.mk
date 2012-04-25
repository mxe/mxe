# This file is part of mingw-cross-env.
# See doc/index.html for further information.

PKG             := ocaml-findlib
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 85d28df1a5a5c72a7a1b1c40ff89ea592507e6bd
$(PKG)_SUBDIR   := findlib-$($(PKG)_VERSION)
$(PKG)_FILE     := findlib-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.camlcity.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := ocaml-core

define $(PKG)_UPDATE
    wget -q -O- 'http://download.camlcity.org/download' | \
	$(SED) -n 's,.*findlib-\([0-9][^>]*\)\.tar.*,\1,ip' | \
	sort | \
	tail -1
endef

define $(PKG)_BUILD
	# build
	rm -f $(1)/src/findlib/ocaml_args.ml
	cd '$(1)' && ./configure \
	  -config $(PREFIX)/$(TARGET)/etc/findlib.conf \
	  -bindir $(PREFIX)/$(TARGET)/bin \
	  -sitelib $(PREFIX)/$(TARGET)/lib/ocaml \
	  -mandir $(PREFIX)/$(TARGET)/share/man \
	  -with-toolbox \
	  -no-topfind
    # no-topfind because it wants to be installed in /usr/bin, and creates blocking
	# error
	cd '$(1)' && make all
	cd '$(1)' && make opt

	# Install findlib
	cd '$(1)' && make install
	cp -f $(PREFIX)/$(TARGET)/bin/ocamlfind $(PREFIX)/bin/$(TARGET)-ocamlfind
	# Override etc/findlib.conf with our own version
	rm -f $(PREFIX)/$(TARGET)/etc/findlib.conf
	(echo 'stdlib="$(PREFIX)/$(TARGET)/lib/ocaml"'; \
     echo 'ldconf="$(PREFIX)/$(TARGET)/lib/ocaml/ld.conf"'; \
	 echo 'destdir="$(PREFIX)/$(TARGET)/lib/ocaml"'; \
	 echo 'path="$(PREFIX)/$(TARGET)/lib/ocaml"'; \
	 echo 'ocamlc="$(TARGET)-ocamlc"'; \
	 echo 'ocamlopt="$(TARGET)-ocamlopt"'; \
	 echo 'ocamldep="$(TARGET)-ocamldep"') \
     > $(PREFIX)/$(TARGET)/etc/findlib.conf

	# test
	cp '$(2).ml' '$(1)/test.ml'
	cd '$(1)' && '$(TARGET)-ocamlfind' opt test.ml
endef
