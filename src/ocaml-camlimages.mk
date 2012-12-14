# This file is part of MXE.
# See index.html for further information.

PKG				:= ocaml-camlimages
$(PKG)_IGNORE	:=
$(PKG)_CHECKSUM := 3ff44142386970003d3cff1446ad351b36759a8e
$(PKG)_SUBDIR	:= camlspotter-camlimages-c803efa9d5d3
$(PKG)_FILE		:= v$($(PKG)_VERSION).tar.gz
$(PKG)_URL		:= https://bitbucket.org/camlspotter/camlimages/get/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS		:= ocaml-findlib freetype libpng giflib tiff ocaml-lablgtk2

define $(PKG)_UPDATE
	wget -q -O- 'https://bitbucket.org/camlspotter/camlimages/downloads' | \
	$(SED) -n 's,.*camlimages-\([0-9][^>]*\)\.tar.*,\1,ip' | \
	head -1
endef

define $(PKG)_BUILD
	cd '$(1)' && cp -f doc/old/* doc/
	cd '$(1)' && autoreconf -fi
	cd '$(1)' && ./configure \
		--prefix '$(PREFIX)/$(TARGET)' \
		--build="`config.guess`" \
		--with-lablgtk2=yes \
		--host $(TARGET) \
		--disable-bytecode-library \
		--disable-shared
    $(SED) -i 's,sed,$(SED),g' $(1)/Makefile
    $(SED) -i 's,sed,$(SED),g' $(1)/src/Makefile
    $(MAKE) -C '$(1)' -j 1 install
	# test
	cp '$(2).ml' '$(1)/test.ml'
	cd '$(1)' && '$(TARGET)-ocamlfind' opt -linkpkg -package camlimages test.ml
endef
