# This file is part of mingw-cross-env.
# See doc/index.html for further information.

PKG             := ocaml-flexdll
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 7ca63bf8d6c731fd95e0d434a8cfbcc718b99d62
$(PKG)_SUBDIR   := flexdll
$(PKG)_FILE     := flexdll-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://alain.frisch.fr/flexdll/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc ocaml-native

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://alain.frisch.fr/flexdll/?C=M;O=D' | \
    $(SED) -n 's,.*flexdll-\([0-9][^>]*\)\.tar.gz.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        CHAINS=mingw \
        MINGW_PREFIX=$(TARGET) \
        OCAMLOPT=$(PREFIX)/$(TARGET)/bin/ocaml-native/ocamlopt \
        all
    mkdir -p '$(PREFIX)/$(TARGET)/lib/ocaml/flexdll'
    cd '$(1)' && mv flexlink.exe flexlink
    cd '$(1)' && $(INSTALL) -m 0755 flexdll.h '$(PREFIX)/$(TARGET)/include'
    cd '$(1)' && $(INSTALL) -m 0755 flexlink flexdll_mingw.o \
        flexdll_initer_mingw.o \
        '$(PREFIX)/$(TARGET)/lib/ocaml/flexdll'
    # create flexdll scripts
    (echo '#!/bin/sh'; \
     echo 'FLEXDIR="$(PREFIX)/$(TARGET)/lib/ocaml/flexdll" exec '$(PREFIX)/$(TARGET)/lib/ocaml/flexdll/flexlink' -I $(PREFIX)/$(TARGET)/lib -chain mingw -nocygpath "$$@"') \
            > '$(PREFIX)/bin/$(TARGET)-flexlink'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-flexlink'

    echo "testing flexlink..."
    $(MAKE) -C '$(1)/test' -j '$(JOBS)' dump.exe plug1.dll plug2.dll CC=$(TARGET)-gcc O=o FLEXLINK=$(TARGET)-flexlink
    #works if wine is installed :
    #cd '$(1)/test' && ./dump.exe plug1.dll plug2.dll
endef
