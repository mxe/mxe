# This file is part of MXE.
# See index.html for further information.

PKG             := ocaml-findlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4
$(PKG)_CHECKSUM := 6e4065e5d79d31176ec213ff94599c4eae17c3904c2896e845d0379a99f1bdf8
$(PKG)_SUBDIR   := findlib-$($(PKG)_VERSION)
$(PKG)_FILE     := findlib-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.camlcity.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ocaml-core

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://download.camlcity.org/download' | \
    $(SED) -n 's,.*findlib-\([0-9][^>]*\)\.tar.*,\1,ip' | \
    $(SORT) | \
    tail -1
endef

define $(PKG)_BUILD
    # build
    rm -f $(1)/src/findlib/ocaml_args.ml
    cd '$(1)' && \
        PATH="$(PREFIX)/$(TARGET)/bin/ocaml-native:$(PATH)" \
        ./configure \
            -config $(PREFIX)/$(TARGET)/etc/findlib.conf \
            -bindir $(PREFIX)/$(TARGET)/bin \
            -sitelib $(PREFIX)/$(TARGET)/lib/ocaml \
            -mandir $(PREFIX)/$(TARGET)/share/man \
            -with-toolbox \
            -no-topfind

    # no-topfind because it wants to be installed in /usr/bin, and creates blocking
    # error
    $(MAKE) -C '$(1)' -j '$(JOBS)' PATH="$(PREFIX)/$(TARGET)/bin/ocaml-native:$(PATH)" all
    $(MAKE) -C '$(1)' -j '$(JOBS)' PATH="$(PREFIX)/$(TARGET)/bin/ocaml-native:$(PATH)" opt

    # Install findlib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
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
    '$(TARGET)-ocamlfind' opt \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        < '$(2).ml'

endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
