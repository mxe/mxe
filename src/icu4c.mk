# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := icu4c
$(PKG)_WEBSITE  := https://github.com/unicode-org/icu
$(PKG)_DESCR    := ICU4C
$(PKG)_VERSION  := 64.2
$(PKG)_MAJOR    := $(word 1,$(subst ., ,$($(PKG)_VERSION)))
$(PKG)_CHECKSUM := 627d5d8478e6d96fc8c90fed4851239079a561a6a8b9e48b0892f24e82d31d6c
$(PKG)_SUBDIR   := icu
$(PKG)_FILE     := $(PKG)-$(subst .,_,$($(PKG)_VERSION))-src.tgz
$(PKG)_URL      := https://sourceforge.net/projects/icu/files/ICU4C/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/icu/files/ICU4C/' | \
    $(SED) -n 's,.*/projects/.*/.*/.*/\([0-9]\+[^"]*\)/".*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD_COMMON
    cd '$(SOURCE_DIR)/source' && autoreconf -fi
    mkdir '$(BUILD_DIR)/$(PKG).native'
    cd '$(BUILD_DIR)/$(PKG).native' && '$(SOURCE_DIR)/source/configure' \
        CC=$(BUILD_CC) CXX=$(BUILD_CXX)
        $(MAKE) -C '$(BUILD_DIR)/$(PKG).native' -j $(JOBS) VERBOSE=1

    mkdir '$(BUILD_DIR)/$(PKG).cross'
    cd '$(BUILD_DIR)/$(PKG).cross' && '$(SOURCE_DIR)/source/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-cross-build='$(BUILD_DIR)/$(PKG).native' \
        CFLAGS='-DU_USING_ICU_NAMESPACE=0' \
        CXXFLAGS='-std=c++11' \
        LIBS='-lmsvcr100' \
        SHELL=$(SHELL)
    
    rm -fv '$(PREFIX)/$(TARGET)/lib/libicu*.dll.a'
    $(MAKE) -C '$(BUILD_DIR)/$(PKG).cross' -j $(JOBS) all-recursive VERBOSE=1 SHELL=$(SHELL)
    $(MAKE) -C '$(BUILD_DIR)/$(PKG).cross' -j 1 install VERBOSE=1 SHELL=$(SHELL)
    ln -sf '$(PREFIX)/$(TARGET)/bin/icu-config' '$(PREFIX)/bin/$(TARGET)-icu-config'
endef

define $(PKG)_BUILD_SHARED
    $(call $(PKG)_BUILD_COMMON)
    # icu4c installs its DLLs to lib/. Move them to bin/.
    mv "$(PREFIX)/$(TARGET)/lib/libicudt$($(PKG)_MAJOR).dll" "$(PREFIX)/$(TARGET)/lib/icudt$($(PKG)_MAJOR).dll"
    cd "$(PREFIX)/$(TARGET)/lib" && ln -fs "icudt$($(PKG)_MAJOR).dll" "icudt.dll"
    mv -fv $(PREFIX)/$(TARGET)/lib/icu*.dll "$(PREFIX)/$(TARGET)/bin/"
    # add symlinks icu*<version>.dll.a to icu*.dll.a
    for lib in $(shell ls '$(PREFIX)/$(TARGET)/lib/' | grep 'icu.*\.dll\.a' | cut -d '.' -f 1 | tr '\n' ' '); \
    do \
        ln -fs "$(PREFIX)/$(TARGET)/lib/$${lib}.dll.a" "$(PREFIX)/$(TARGET)/lib/$${lib}$($(PKG)_MAJOR).dll.a"; \
    done
endef

define $(PKG)_BUILD
    $(call $(PKG)_BUILD_COMMON)
    # Static libs are prefixed with an `s` but the config script
    # doesn't detect it properly, despite the STATIC_PREFIX="s" line
    $(SED) -i 's,ICUPREFIX="icu",ICUPREFIX="sicu",' '$(PREFIX)/$(TARGET)/bin/icu-config'
endef
