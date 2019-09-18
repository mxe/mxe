# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := icu4c
$(PKG)_WEBSITE  := https://ssl.icu-project.org/
$(PKG)_DESCR    := ICU4C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 64.2
$(PKG)_MAJOR    := $(word 1,$(subst ., ,$($(PKG)_VERSION)))
$(PKG)_CHECKSUM := 627d5d8478e6d96fc8c90fed4851239079a561a6a8b9e48b0892f24e82d31d6c
$(PKG)_SUBDIR   := icu
$(PKG)_FILE     := $(PKG)-$(subst .,_,$($(PKG)_VERSION))-src.tgz
$(PKG)_URL      := https://ssl.icu-project.org/files/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
	$(WGET) --user-agent='Wget/1.19.5' -q -O- 'https://ssl.icu-project.org/files/icu4c/' | \
	grep -o 'href="[0-9.]*/' | \
	grep -o '[0-9.]*' | \
	$(SORT) --version-sort | \
	tail -1
endef

define $(PKG)_BUILD_COMMON
    cd '$(PKG)/source' && autoreconf -fi
    mkdir '$(PKG).native' && cd '$(PKG).native' && '$(PKG)/source/configure' \
        CC=$(BUILD_CC) CXX=$(BUILD_CXX) 
		$(MAKE) -C '$(PKG).native' -j '$(JOBS)'

    mkdir '$(PKG).cross' && cd '$(PKG).cross' && '$(PKG)/source/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-cross-build='$(PKG).native' \
        CFLAGS=-DU_USING_ICU_NAMESPACE=0 \
        CXXFLAGS='$(CXXFLAGS) -std=c++11' \
        LIBS="-lmsvcr100" \
        SHELL=bash
		LIBS="-lmsvcr100" $(MAKE) -C '$(PKG).cross' -j '$(JOBS)' install
    	ln -sf '$(PREFIX)/$(TARGET)/bin/icu-config' '$(PREFIX)/bin/$(TARGET)-icu-config'
    	rm -fv '$(PREFIX)/$(TARGET)/lib/icudt.dll' && rm -fv '$(PREFIX)/$(TARGET)/lib/icudt.dll.a'
    	rm -fv '$(PREFIX)/$(TARGET)/lib/icudt$($(PKG)_MAJOR).dll'
endef

define $(PKG)_BUILD_SHARED
    $($(PKG)_BUILD_COMMON)
	rm -fv '$(PREFIX)/$(TARGET)/lib/icudt.dll' && rm -fv '$(PREFIX)/$(TARGET)/lib/icudt.dll.a'
    LIBS="-lmsvcr100" $(MAKE) -C '$(PKG).cross/data' -j '$(JOBS)' install
    # icu4c installs its DLLs to lib/. Move them to bin/.
	mv '$(PREFIX)/$(TARGET)/lib/icudt$($(PKG)_MAJOR).dll' '$(PREFIX)/$(TARGET)/lib/icudt$($(PKG)_MAJOR).dll' && \
	cd '$(PREFIX)/$(TARGET)/lib' && ln -fs 'icudt$($(PKG)_MAJOR).dll' 'icudt.dll'
   	mv -fv $(PREFIX)/$(TARGET)/lib/icu*.dll '$(PREFIX)/$(TARGET)/bin/'
    # add symlinks icu*<version>.dll.a to icu*.dll.a
    for lib in `ls '$(PREFIX)/$(TARGET)/lib/' | grep 'icu.*\.dll\.a' | cut -d '.' -f 1 | tr '\n' ' '`; \
    do \
        ln -fs "$(PREFIX)/$(TARGET)/lib/$${lib}.dll.a" "$(PREFIX)/$(TARGET)/lib/$${lib}$($(PKG)_MAJOR).dll.a"; \
    done
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_COMMON)
    # Static libs are prefixed with an `s` but the config script
    # doesn't detect it properly, despite the STATIC_PREFIX="s" line
    $(SED) -i 's,ICUPREFIX="icu",ICUPREFIX="sicu",' '$(PREFIX)/$(TARGET)/bin/icu-config'
endef
