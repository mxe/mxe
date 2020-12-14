# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libusb1
$(PKG)_WEBSITE  := https://libusb.info/
$(PKG)_DESCR    := LibUsb-1.0
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.24
$(PKG)_CHECKSUM := 7efd2685f7b327326dcfb85cee426d9b871fd70e22caa15bb68d595ce2a2b12a
$(PKG)_SUBDIR   := libusb-$($(PKG)_VERSION)
$(PKG)_FILE     := libusb-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/libusb/libusb-1.0/libusb-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/libusb/files/libusb-1.0/' | \
    grep -i 'libusb/files/libusb-1.0' | \
    $(SED) -n 's,.*/libusb-1.0/libusb-\([0-9\.]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS=-D_WIN32_WINNT=0x0500
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Wextra -Werror \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libusb1.exe' \
        `'$(TARGET)-pkg-config' libusb-1.0 --cflags --libs`
endef
