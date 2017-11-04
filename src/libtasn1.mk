# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libtasn1
$(PKG)_WEBSITE  := https://www.gnu.org/software/libtasn1/
$(PKG)_DESCR    := GNU Libtasn1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.12
$(PKG)_CHECKSUM := 6753da2e621257f33f5b051cc114d417e5206a0818fe0b1ecfd6153f70934753
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

$(PKG)_UPDATE = \
    $(call GET_LATEST_VERSION,https://ftp.gnu.org/gnu/libtasn1)

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -ansi -pedantic \
        '$(SOURCE_DIR)/tests/copynode.c' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
