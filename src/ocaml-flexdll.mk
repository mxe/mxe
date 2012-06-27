# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# zlib
PKG				:= ocaml-flexdll
$(PKG)_IGNORE	:=
$(PKG)_CHECKSUM := 585f066f890c7dca95be7541b4647128335f7df9
#$(PKG)_CHECKSUM := 76e3d9a8d1182d8ff315793c3ffbbc8e49c92888
$(PKG)_SUBDIR	:= flexdll
$(PKG)_FILE		:= flexdll-$($(PKG)_VERSION).tar.gz
$(PKG)_URL		:= http://alain.frisch.fr/flexdll/$($(PKG)_FILE)
$(PKG)_DEPS		:= gcc

define $(PKG)_UPDATE
	wget -q -O- 'http://alain.frisch.fr/flexdll/' | \
	$(SED) -n 's,.*flexdll-\([0-9][^>]*\)\.tar.gz.*,\1,ip' | \
	head -1
endef

define $(PKG)_BUILD
	$(SED) -i "s,@libdir@,$(PREFIX)/$(TARGET)/lib,g" $(1)/reloc.ml
	$(MAKE) -C '$(1)' -j '$(JOBS)' \
		TOOLCHAIN=mingw \
		MINGW_PREFIX=$(TARGET) \
		flexlink.exe build_mingw
	cd '$(1)' && cp flexlink.exe flexlink
	cd '$(1)' && $(INSTALL) -m 0755 flexdll.h '$(PREFIX)/$(TARGET)/include'
	mkdir -p '$(PREFIX)/$(TARGET)/lib/ocaml/flexdll'
	cd '$(1)' && $(INSTALL) -m 0755 flexlink.exe flexdll_mingw.o \
		flexdll_initer_mingw.o \
		'$(PREFIX)/$(TARGET)/lib/ocaml/flexdll'
	ln -sf '$(PREFIX)/$(TARGET)/lib/ocaml/flexdll/flexlink.exe' '$(PREFIX)/bin/flexlink'
# We choose which object we strip since this is not trivial here..
	strip --remove-section=.comment --remove-section=.note \
		'$(PREFIX)/$(TARGET)/lib/ocaml/flexdll/flexlink.exe'

	echo "testing flexlink..."
	$(MAKE) -C '$(1)/test' -j '$(JOBS)' dump.exe plug1.dll plug2.dll CC=$(TARGET)-gcc O=o CHAIN=mingw
	#works if wine is installed :
	#cd '$(1)/test' && ./dump.exe plug1.dll plug2.dll
endef
