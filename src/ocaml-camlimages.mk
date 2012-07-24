# This file is part of MXE.
# See index.html for further information.

PKG				:= ocaml-camlimages
$(PKG)_IGNORE	:=
$(PKG)_CHECKSUM := 18288b2a9ecd8be71f004303cde23f34ffa7c1c5
#REVISION : wget -q -O- 'https://bitbucket.org/camlspotter/camlimages/downloads' | sed -n 's,.*camlspotter/camlimages/src/\(.*\)">caml.*,\1,ip'
$(PKG)_SUBDIR	:= camlspotter-camlimages-ee82aa9b74ac
$(PKG)_FILE		:= camlimages-$($(PKG)_VERSION).tar.gz
$(PKG)_URL		:= https://bitbucket.org/camlspotter/camlimages/get/$($(PKG)_FILE)
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
	$(MAKE) -C '$(1)' -j '$(JOBS)' install
	# test
	cp '$(2).ml' '$(1)/test.ml'
	cd '$(1)' && '$(TARGET)-ocamlfind' opt -linkpkg -package camlimages test.ml
endef
