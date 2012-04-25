# This file is part of mingw-cross-env.
# See doc/index.html for further information.

PKG             := ocaml-lablgtk2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := fd184418ccbc542825748ca63fba75138d2ea561
$(PKG)_SUBDIR   := lablgtk-$($(PKG)_VERSION)
$(PKG)_FILE     := lablgtk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://forge.ocamlcore.org/frs/download.php/561/$($(PKG)_FILE)
$(PKG)_DEPS     := ocaml-core ocaml-findlib gtk2

define $(PKG)_UPDATE
	wget -q -O- 'http://forge.ocamlcore.org/frs/?group_id=220' | \
	sed -n 's,.*lablgtk-\(2[^>]*\)\.tar.*,\1,ip' | \
	sort | \
	tail -1
endef

define $(PKG)_BUILD
	cp -f '$(1)/config.make.mingw-new' '$(1)/config.make'
	$(SED) -i "s,@target@,$(TARGET),g" $(1)/config.make
	$(SED) -i "s,@prefix@,$(PREFIX),g" $(1)/config.make
	$(SED) -i "s,@gtkcflags@,$(shell $(PREFIX)/bin/$(TARGET)-pkg-config --cflags gtk+-2.0),g" $(1)/config.make
	$(SED) -i "s,@gtk_libs@,$(shell $(PREFIX)/bin/$(TARGET)-pkg-config --libs gtk+-2.0),g" $(1)/config.make
	make -C '$(1)/src' lablgtkopt
	mkdir -p $(PREFIX)/$(TARGET)/lib/ocaml/lablgtk2
	cp -f $(1)/META $(PREFIX)/$(TARGET)/lib/ocaml/lablgtk2
	cp -f $(1)/src/dlllablgtk2.dll $(PREFIX)/$(TARGET)/lib/ocaml/stublibs/
	cp -f $(1)/src/*.mli $(PREFIX)/$(TARGET)/lib/ocaml/lablgtk2/
	cp -f $(1)/src/*.cmi $(PREFIX)/$(TARGET)/lib/ocaml/lablgtk2/
	cp -f $(1)/src/*.cmx $(PREFIX)/$(TARGET)/lib/ocaml/lablgtk2/
	cp -f $(1)/src/*.cmxa $(PREFIX)/$(TARGET)/lib/ocaml/lablgtk2/
	cp -f $(1)/src/*.cmxs $(PREFIX)/$(TARGET)/lib/ocaml/lablgtk2/
	cp -f $(1)/src/*.a $(PREFIX)/$(TARGET)/lib/ocaml/lablgtk2/
	cp -f $(1)/src/*.h $(PREFIX)/$(TARGET)/lib/ocaml/lablgtk2/
	cp -f $(1)/src/gtkInit.o $(PREFIX)/$(TARGET)/lib/ocaml/lablgtk2/
	cp -f $(1)/src/gtkThread.o $(PREFIX)/$(TARGET)/lib/ocaml/lablgtk2/
	# test
	cp '$(2).ml' '$(1)/test.ml'
	cd '$(1)' && '$(TARGET)-ocamlfind' opt -package lablgtk2 -linkpkg test.ml
endef
