# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ocaml-xml-light
$(PKG)_WEBSITE  := http://tech.motion-twin.com/xmllight.html
$(PKG)_DESCR    := xml-light
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2
$(PKG)_CHECKSUM := fdb205e8b3a25922e46fca52aea449b9a2de4000c5442487e7e74d79f1e2274a
$(PKG)_SUBDIR   := xml-light
$(PKG)_FILE     := xml-light-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://tech.motion-twin.com/zip/$($(PKG)_FILE)
$(PKG)_DEPS     := cc ocaml-findlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://tech.motion-twin.com/xmllight.html' | \
    $(SED) -n 's,.*xml-light-\(.*\)\.zip.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i "s,@target@,$(TARGET),g"            '$(1)/Makefile'
    $(SED) -i 's,ocamllex,$(TARGET)-ocamllex,g'   '$(1)/Makefile'
    $(SED) -i 's,ocamlyacc,$(TARGET)-ocamlyacc,g' '$(1)/Makefile'
    $(SED) -i "s,@installdir@,$(PREFIX)/$(TARGET)/lib/ocaml/xml-light,g" $(1)/Makefile
    $(MAKE) -C '$(1)' xml_parser.ml
    $(MAKE) -C '$(1)' -j 1 # without separated previous step, does not work
    mkdir -p $(PREFIX)/$(TARGET)/lib/ocaml/xml-light
    # install..
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
    (echo 'version="$($(PKG)_VERSION)"'; \
     echo 'directory="+xml-light"'; \
     echo 'archive(byte) = "xml-light.cma"'; \
     echo 'archive(native) = "xml-light.cmxa"') \
     > $(PREFIX)/$(TARGET)/lib/ocaml/xml-light/META
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
