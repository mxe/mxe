# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := icu4c
$(PKG)_WEBSITE  := https://github.com/unicode-org/icu
$(PKG)_DESCR    := ICU4C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 65.1
$(PKG)_MAJOR    := $(word 1,$(subst ., ,$($(PKG)_VERSION)))
$(PKG)_CHECKSUM := 53e37466b3d6d6d01ead029e3567d873a43a5d1c668ed2278e253b683136d948
$(PKG)_GH_CONF  := unicode-org/icu/releases/latest,release-,,,-
$(PKG)_SUBDIR   := icu
$(PKG)_URL      := $($(PKG)_WEBSITE)/releases/download/release-$(subst .,-,$($(PKG)_VERSION))/icu4c-$(subst .,_,$($(PKG)_VERSION))-src.tgz
$(PKG)_DEPS     := cc $(BUILD)~$(PKG)

$(PKG)_TARGETS       := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_BUILD_$(BUILD)
    # cross build requires artefacts from native build tree
    rm -rf '$(PREFIX)/$(BUILD)/$(PKG)'
    $(INSTALL) -d '$(PREFIX)/$(BUILD)/$(PKG)'
    cd '$(PREFIX)/$(BUILD)/$(PKG)' && '$(SOURCE_DIR)/source/configure' \
        CC=$(BUILD_CC) \
        CXX=$(BUILD_CXX) \
        --enable-tests=no \
        --enable-samples=no
    $(MAKE) -C '$(PREFIX)/$(BUILD)/$(PKG)' -j '$(JOBS)'
endef

define $(PKG)_BUILD_COMMON
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/source/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-cross-build='$(PREFIX)/$(BUILD)/$(PKG)' \
        CFLAGS=-DU_USING_ICU_NAMESPACE=0 \
        CXXFLAGS='--std=gnu++0x' \
        SHELL=$(SHELL) \
        LIBS='-lstdc++' \
        $($(PKG)_CONFIGURE_OPTS)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
    ln -sf '$(PREFIX)/$(TARGET)/bin/icu-config' '$(PREFIX)/bin/$(TARGET)-icu-config'
endef

define $(PKG)_BUILD_TEST
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' icu-uc icu-io --cflags --libs`
endef

define $(PKG)_BUILD_SHARED
    $($(PKG)_BUILD_COMMON)
    # icu4c installs its DLLs to lib/. Move them to bin/.
    mv -fv $(PREFIX)/$(TARGET)/lib/icu*.dll '$(PREFIX)/$(TARGET)/bin/'
    # add symlinks icu*<version>.dll.a to icu*.dll.a
    for lib in $$(ls '$(PREFIX)/$(TARGET)/lib/' | grep 'icu.*\.dll\.a' | cut -d '.' -f 1 | tr '\n' ' '); \
    do \
        ln -fs "$(PREFIX)/$(TARGET)/lib/$${lib}.dll.a" "$(PREFIX)/$(TARGET)/lib/$${lib}$($(PKG)_MAJOR).dll.a"; \
    done
    $($(PKG)_BUILD_TEST)
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_COMMON)
    # Static libs are prefixed with an `s` but the config script
    # doesn't detect it properly, despite the STATIC_PREFIX="s" line
    $(SED) -i 's,ICUPREFIX="icu",ICUPREFIX="sicu",' '$(PREFIX)/$(TARGET)/bin/icu-config'
    $($(PKG)_BUILD_TEST)
endef
