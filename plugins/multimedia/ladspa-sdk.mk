# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ladspa-sdk
$(PKG)_VERSION  := 1.13
$(PKG)_CHECKSUM := b5ed3f4f253a0f6c1b7a1f4b8cf62376ca9f51d999650dd822650c43852d306b
$(PKG)_SUBDIR   := ladspa_sdk/src
$(PKG)_FILE     := ladspa-sdk_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_HOME     := http://http.debian.net/debian/pool/main/l/ladspa-sdk
$(PKG)_URL      := $($(PKG)_HOME)/$($(PKG)_FILE)
$(PKG)_DEPS     := dlfcn-win32

define $(PKG)_UPDATE
    $(WGET) -q -O- http://http.debian.net/debian/pool/main/l/ladspa-sdk | \
    $(SED) -n 's,.*ladspa-sdk_\([0-9][^>]*\)\.orig\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
	mkdir -p $(1)/../plugins $(1)/../bin
    $(MAKE) targets PROGRAMS='' \
		-C '$(1)' -j '$(JOBS)' \
		CC='$(TARGET)-gcc -L$(PREFIX)/$(TARGET)/lib' \
		LD='$(TARGET)-gcc -L$(PREFIX)/$(TARGET)/lib' \
		CPP='$(TARGET)-g++ -L$(PREFIX)/$(TARGET)/lib' \
		CFLAGS='-I. -O3'
	cp $(1)/ladspa.h $(PREFIX)/$(TARGET)/include/
	mkdir -p $(PREFIX)/$(TARGET)/lib/ladspa/
	cp $(1)/../plugins/* $(PREFIX)/$(TARGET)/lib/ladspa/
endef
