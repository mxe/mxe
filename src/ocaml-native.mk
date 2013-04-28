# This file is part of mingw-cross-env.
# See doc/index.html for further information.

PKG             := ocaml-native
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 5abf04cd4fccfcc980e8592995b9159014f23f53
$(PKG)_SUBDIR   := ocaml-$($(PKG)_VERSION)
$(PKG)_FILE     := ocaml-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://caml.inria.fr/pub/distrib/ocaml-$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://caml.inria.fr/download.en.html' | \
    $(SED) -n 's,.*ocaml-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # the following script would require ocamlbuild with an option '-ocamlfind'
    # to work:
    #(echo '#!/bin/sh'; \
    # echo 'exec $(PREFIX)/bin/ocamlbuild -use-ocamlfind -ocamlfind $(TARGET)-ocamlfind "$$@"') \
    # > '$(PREFIX)/bin/$(TARGET)-ocamlbuild'
    # chmod 0755 '$(PREFIX)/bin/$(TARGET)-ocamlbuild'
    # As it is not the case, we patche ocaml source to get ocamlbuild use $(TARGET)-ocamlc, $(TARGET)-ocamlfind, ...
    cd '$(1)' && ./configure \
        -prefix '$(PREFIX)/$(TARGET)' \
        -bindir '$(PREFIX)/$(TARGET)/bin/ocaml-native' \
        -libdir '$(PREFIX)/$(TARGET)/lib/ocaml-native' \
        -no-tk \
        -no-shared-libs \
        -verbose
    $(MAKE) -C '$(1)' -j 1 world opt
    $(SED) -i "s,@target@,$(TARGET),g" $(1)/ocamlbuild/options.ml
    $(SED) -i "s,@target@,$(TARGET),g" $(1)/ocamlbuild/findlib.ml
    $(MAKE) -C '$(1)' -j '$(JOBS)' ocamlbuild.native
    cp -f '$(1)/_build/ocamlbuild/ocamlbuild.native' $(PREFIX)/bin/$(TARGET)-ocamlbuild
    $(MAKE) -C '$(1)' install
    # Rename all the binaries to target-binary
    for f in camlp4 camlp4oof camlp4of camlp4o camlp4rf camlp4r camlp4orf \
      ocamldoc ocamllex ocamlyacc; do \
        cp -f $(PREFIX)/$(TARGET)/bin/ocaml-native/$$f $(PREFIX)/bin/$(TARGET)-$$f; \
    done
    # test will be done once cross ocamlopt is built in package ocaml-core
endef
