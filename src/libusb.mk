# LibUsb

PKG             := libusb
$(PKG)_VERSION  := 0.1.12.1
$(PKG)_CHECKSUM := b13fd5a0042152bc5d5e538533aa93754fa472a7
$(PKG)_SUBDIR   := $(PKG)-win32-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-win32-src-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://libusb-win32.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/libusb-win32/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=78138&package_id=79216' | \
    grep 'libusb-win32-src-' | \
    $(SED) -n 's,.*libusb-win32-src-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # convert DOS line endings
    $(SED) 's,\r$$,,' -i '$(1)/Makefile'

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
    $(INSTALL) -m664 '$(1)/src/usb.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m664 '$(1)/libusb.a'  '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m664 '$(1)/libusbd.a' '$(PREFIX)/$(TARGET)/lib/'
endef
