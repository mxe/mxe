# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := icu4c
$(PKG)_WEBSITE  := https://github.com/unicode-org/icu
$(PKG)_DESCR    := ICU4C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 66.1
$(PKG)_MAJOR    := $(word 1,$(subst ., ,$($(PKG)_VERSION)))
$(PKG)_CHECKSUM := 52a3f2209ab95559c1cf0a14f24338001f389615bf00e2585ef3dbc43ecf0a2e
$(PKG)_GH_CONF  := unicode-org/icu/releases/latest,release-,,,-
$(PKG)_SUBDIR   := icu
$(PKG)_URL      := $($(PKG)_WEBSITE)/releases/download/release-$(subst .,-,$($(PKG)_VERSION))/icu4c-$(subst .,_,$($(PKG)_VERSION))-src.tgz
$(PKG)_DEPS     := cc $(BUILD)~$(PKG) pe-util

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
    rm -fv $(shell echo "$(PREFIX)/$(TARGET)"/{bin,lib}/{lib,libs,}icu'*'.{a,dll,dll.a})
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/source/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-cross-build='$(PREFIX)/$(BUILD)/$(PKG)' \
        --enable-icu-config=no \
        CXXFLAGS='--std=gnu++0x' \
        SHELL=$(SHELL) \
        LIBS='-lstdc++' \
        $($(PKG)_CONFIGURE_OPTS)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 SO_TARGET_VERSION_SUFFIX=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1 SO_TARGET_VERSION_SUFFIX=
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

    # stub data is icudt.dll, actual data is libicudt.dll - prefer actual
    test ! -e '$(PREFIX)/$(TARGET)/lib/libicudt$($(PKG)_MAJOR).dll' \
        || mv -fv '$(PREFIX)/$(TARGET)/lib/libicudt$($(PKG)_MAJOR).dll' '$(PREFIX)/$(TARGET)/bin/icudt$($(PKG)_MAJOR).dll'

    $($(PKG)_BUILD_TEST)

    # bundle test to verify deployment
    rm -rfv '$(PREFIX)/$(TARGET)/bin/test-$(PKG)' '$(PREFIX)/$(TARGET)/bin/test-$(PKG).zip'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/test-$(PKG)'
    cp $$($(TARGET)-peldd --all '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe') '$(PREFIX)/$(TARGET)/bin/test-$(PKG)'
    cd '$(PREFIX)/$(TARGET)/bin' && 7za a -tzip test-$(PKG).zip test-$(PKG)
    rm -rfv '$(PREFIX)/$(TARGET)/bin/test-$(PKG)'
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_COMMON)
    $($(PKG)_BUILD_TEST)
endef
