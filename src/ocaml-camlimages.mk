# This file is part of MXE.
# See index.html for further information.

PKG             := ocaml-camlimages
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.1
$(PKG)_CHECKSUM := 3ff44142386970003d3cff1446ad351b36759a8e
$(PKG)_SUBDIR   := camlspotter-camlimages-c803efa9d5d3
$(PKG)_FILE     := v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://bitbucket.org/camlspotter/camlimages/get/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc ocaml-findlib freetype libpng giflib tiff ocaml-lablgtk2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://bitbucket.org/camlspotter/camlimages/downloads' | \
    $(SED) -n 's,.*get/v\([0-9][^>]*\)\.tar.*,\1,ip' | \
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
    '$(TARGET)-ocamlfind' opt -linkpkg \
        -package camlimages \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        < '$(2).ml'
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
