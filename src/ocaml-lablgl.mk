# This file is part of MXE.
# See index.html for further information.

PKG             := ocaml-lablgl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.05
$(PKG)_CHECKSUM := d8ff03e35b970d2b23a942f9e6ed65da5a6c123986bd0ecf5424a6205af34b61
$(PKG)_SUBDIR   := lablgl-$($(PKG)_VERSION)
$(PKG)_FILE     := lablgl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://wwwfun.kurims.kyoto-u.ac.jp/soft/olabl/dist/$($(PKG)_FILE)
$(PKG)_URL_2    := https://forge.ocamlcore.org/frs/download.php/1254/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtkglarea ocaml-findlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgl.html' | \
    $(SED) -n 's,.*lablgl-\([^>]*\)\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    (echo 'CAMLC = $(TARGET)-ocamlc'; \
     echo 'CAMLOPT = $(TARGET)-ocamlopt'; \
     echo 'BINDIR = $(PREFIX)/$(TARGET)/bin'; \
     echo '#XINCLUDES = -I$(PREFIX)/$(TARGET)/X11R6/include'; \
     echo '#XLIBS = -lXext -lXmu -lX11'; \
     echo '#TKINCLUDES = -I(PREFIX)/$(TARGET)/include'; \
     echo 'GLINCLUDES = -DHAS_GLEXT_H -DGL_GLEXT_PROTOTYPES -DGLU_VERSION_1_3'; \
     echo 'GLLIBS = -lglu32 -lopengl32'; \
     echo 'GLUTLIBS = $(shell $(PREFIX)/bin/$(TARGET)-pkg-config --libs glut)'; \
     echo 'RANLIB = $(TARGET)-ranlib'; \
     echo 'TOOLCHAIN = unix'; \
     echo 'XB ='; \
     echo 'XE ='; \
     echo 'XS ='; \
     echo '# NB: The next two lines have a space after them.'; \
     echo 'MKLIB = $(TARGET)-ar rcs '; \
     echo 'MKDLL = $(TARGET)-ocamlmklib -o '; \
     echo 'LIBDIR = $(PREFIX)/$(TARGET)/lib/ocaml'; \
     echo 'DLLDIR = $(PREFIX)/$(TARGET)/lib/ocaml/stublibs'; \
     echo 'INSTALLDIR = $(PREFIX)/$(TARGET)/lib/ocaml/lablGL'; \
     echo '#TOGLDIR=Togl'; \
     echo '#COPTS = $RPM_OPT_FLAGS'; \
     echo 'OCAMLDLL ='; \
     echo 'LIBRARIAN = $(TARGET)-ocamlmklib'; \
     echo 'VAR2DEF=$(TARGET)-ocamlrun $$(SRCDIR)/var2def'; \
     echo 'VAR2SWITCH=$(TARGET)-ocamlrun $$(SRCDIR)/var2switch') \
     > $(1)/Makefile.config
    cd '$(1)' && $(SED) -i 's/ocamlc/$(TARGET)-ocamlc/g' src/Makefile
    cd '$(1)' && $(SED) -i 's/camlp4o/$(TARGET)-camlp4o/g' src/Makefile
    $(MAKE) -C '$(1)' -j 1 lib libopt install
    (echo 'version="$($(PKG)_VERSION)"'; \
     echo 'directory="+lablGL"'; \
     echo 'archive(byte) = "lablgl.cma"'; \
     echo 'archive(native) = "lablgl.cmxa"') \
     > $(PREFIX)/$(TARGET)/lib/ocaml/lablGL/META
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
