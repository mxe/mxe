# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# zlib
PKG				:= ocaml-ocamlbuild
$(PKG)_IGNORE	:=
$(PKG)_CHECKSUM := 05125da055d39dd6fe8fe5c0155b2e9f55c10dfd
$(PKG)_SUBDIR	:= ocaml-$($(PKG)_VERSION)
$(PKG)_FILE		:= ocaml-$($(PKG)_VERSION).tar.gz
$(PKG)_URL		:= http://caml.inria.fr/pub/distrib/ocaml-3.12/$($(PKG)_FILE)
$(PKG)_DEPS		:= ocaml-findlib

define $(PKG)_UPDATE
	wget -q -O- 'http://caml.inria.fr/pub/distrib/ocaml-3.12' | \
	$(SED) -n 's,.*ocaml-\([0-9][^>]*\)\.tar.*,\1,ip' | \
	tail -1
endef

define $(PKG)_BUILD
	# patched ocaml source to get ocamlbuild use $(TARGET)-ocamlc, 
	# $(TARGET)-ocamlfind, ...
	cd '$(1)' && ./configure \
		-prefix '$(PREFIX)/$(TARGET)' \
		-bindir '$(PREFIX)/$(TARGET)/bin' \
		-libdir '$(PREFIX)/$(TARGET)/lib/ocaml' \
		-no-tk \
		-no-shared-libs \
		-verbose
	$(MAKE) -C '$(1)' -j '$(JOBS)' world.opt
	$(SED) -i "s,@target@,$(TARGET),g" $(1)/ocamlbuild/options.ml
	$(SED) -i "s,@target@,$(TARGET),g" $(1)/ocamlbuild/findlib.ml
	$(MAKE) -C '$(1)' -j '$(JOBS)' ocamlbuild.native
	cp -f '$(1)/_build/ocamlbuild/ocamlbuild.native' $(PREFIX)/bin/$(TARGET)-ocamlbuild
	# the following script requires ocamlbuild with option -ocamlfind to work
	#(echo '#!/bin/sh'; \
	# echo 'exec $(PREFIX)/bin/ocamlbuild -use-ocamlfind -ocamlfind $(TARGET)-ocamlfind "$$@"') \
	# > '$(PREFIX)/bin/$(TARGET)-ocamlbuild'
	#chmod 0755 '$(PREFIX)/bin/$(TARGET)-ocamlbuild'
	# test
	mkdir '$(1)/tmp' && cp '$(2).ml' '$(1)/tmp/test.ml'
	cd '$(1)/tmp' && $(TARGET)-ocamlbuild test.native
endef
