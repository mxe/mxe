# This file is part of MXE.
# See index.html for further information.

PKG             := libusb1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.19
$(PKG)_CHECKSUM := 6c502c816002f90d4f76050a6429c3a7e0d84204222cbff2dce95dd773ba6840
$(PKG)_SUBDIR   := libusb-$($(PKG)_VERSION)
$(PKG)_FILE     := libusb-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/libusb/libusb-1.0/libusb-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libusb/files/libusb-1.0/' | \
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
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libusb1.exe' \
        `'$(TARGET)-pkg-config' libusb-1.0 --cflags --libs`
endef
