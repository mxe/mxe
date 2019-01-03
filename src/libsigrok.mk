# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsigrok
$(PKG)_WEBSITE  := https://www.sigrok.org/wiki/Libsigrok
$(PKG)_DESCR    := libsigrok
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.0
$(PKG)_CHECKSUM := 4c8c86779b880a5c419f6c77a08b1147021e5a19fa83b0f3b19da27463c9f3a4
$(PKG)_SUBDIR   := libsigrok-$($(PKG)_VERSION)
$(PKG)_FILE     := libsigrok-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://sigrok.org/download/source/libsigrok/libsigrok-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc glibmm libftdi1 libieee1284 libserialport libzip

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://sigrok.org/download/source/libsigrok)
endef

# Windows builds require the event-abstraction branch of libusb
# github.com/dickens/libusb

define $(PKG)_BUILD
    # build and install the library
    # doxygen is required to build c++ bindings
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        ac_cv_prog_HAVE_DOXYGEN=$(shell which doxygen >/dev/null 2>&1 && echo yes) \
        --enable-cxx \
        --disable-python \
        --disable-ruby \
        --disable-java \
        --with-libserialport \
        --with-libftdi \
        --without-libusb \
        --without-librevisa \
        --without-libgpib \
        --with-libieee1284
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
