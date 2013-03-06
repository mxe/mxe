# This file is part of mingw-cross-env.
# See doc/index.html for further information.

PKG             := ocaml-xml-light
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := e524aa20c34bf45a839363b61bb2cbbf8fcdc6bc
$(PKG)_SUBDIR   := xml-light
$(PKG)_FILE     := xml-light-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://tech.motion-twin.com/zip/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ocaml-findlib

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
    $(MAKE) -C '$(1)' -j 1 # without seperated previous step, does not work
    mkdir -p $(PREFIX)/$(TARGET)/lib/ocaml/xml-light
    # install..
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
    (echo 'version="$($(PKG)_VERSION)"'; \
     echo 'directory="+xml-light"'; \
     echo 'archive(byte) = "xml-light.cma"'; \
     echo 'archive(native) = "xml-light.cmxa"') \
     > $(PREFIX)/$(TARGET)/lib/ocaml/xml-light/META
endef
