# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libserialport
$(PKG)_WEBSITE  := https://sigrok.org/wiki/Libserialport
$(PKG)_DESCR    := libserialport
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.1
$(PKG)_CHECKSUM := 4a2af9d9c3ff488e92fb75b4ba38b35bcf9b8a66df04773eba2a7bbf1fa7529d
$(PKG)_SUBDIR   := libserialport-$($(PKG)_VERSION)
$(PKG)_FILE     := libserialport-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://sigrok.org/download/source/libserialport/libserialport-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://sigrok.org/download/source/libserialport)
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
