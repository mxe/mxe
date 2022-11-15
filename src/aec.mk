# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := aec
$(PKG)_WEBSITE  := https://gitlab.dkrz.de/k202009/libaec
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.6
$(PKG)_CHECKSUM := 31fb65b31e835e1a0f3b682d64920957b6e4407ee5bbf42ca49549438795a288
$(PKG)_SUBDIR   := libaec-v$($(PKG)_VERSION)
$(PKG)_FILE     := libaec-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gitlab.dkrz.de/k202009/libaec/-/archive/v$($(PKG)_VERSION)/libaec-v$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # build test script
    '$(TARGET)-gcc' -W -Wall '$(SOURCE_DIR)/tests/check_szcomp.c' \
         -o \
        '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lsz
endef
