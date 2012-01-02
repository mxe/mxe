# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# LibUsb
PKG             := libusb
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.5.0
$(PKG)_CHECKSUM := a1b1a23f4f1d7dd42e2a861e69d32cdbcea7b879
$(PKG)_SUBDIR   := $(PKG)-win32-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-win32-src-$($(PKG)_VERSION).zip
$(PKG)_WEBSITE  := http://libusb-win32.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)-win32/$(PKG)-win32-releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # convert DOS line endings
    $(SED) -i 's,\r$$,,' '$(1)/Makefile'

    # don't actually build the library (DLL file),
    # just create the DLL import stubs
    $(MAKE) -C '$(1)' -j '$(JOBS)' host_prefix=$(TARGET) libusbd.a
    cd '$(1)' && $(TARGET)-dlltool \
        --dllname libusb0.dll \
        --kill-at \
        --add-stdcall-underscore \
        --def libusb0.def \
        --output-lib libusb.a

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/src/lusb0_usb.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libusb.a'  '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libusbd.a' '$(PREFIX)/$(TARGET)/lib/'
endef
