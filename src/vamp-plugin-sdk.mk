# This file is part of MXE.
# See index.html for further information.

PKG             := vamp-plugin-sdk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5
$(PKG)_CHECKSUM := 7b719f9e4575624b30b335c64c00469d3745aef4bca177f66faf3204f073139d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://code.soundsoftware.ac.uk/attachments/download/690/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    echo 'TODO: Updates for package vamp-plugin-sdk need to be written.' >&2;
    echo $(vamp-plugin-sdk_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && $(MAKE) -f build/Makefile.mingw32 \
        CXX='$(TARGET)-g++' \
        CC='$(TARGET)-gcc' \
        LD='$(TARGET)-ld' \
        AR='$(TARGET)-ar' \
        RANLIB='$(TARGET)-ranlib' \
        sdkstatic

    for f in vamp vamp-sdk vamp-hostsdk; do \
        $(SED) 's,%PREFIX%,$(PREFIX)/$(TARGET),' "$(1)/pkgconfig/$$f.pc.in" \
            > "$(PREFIX)/$(TARGET)/lib/pkgconfig/$$f.pc"; \
    done

    cp -rv '$(1)/vamp' '$(1)/vamp-hostsdk' '$(1)/vamp-sdk' '$(PREFIX)/$(TARGET)/include/'

    $(if $(BUILD_STATIC), \
        $(INSTALL) -m644 '$(1)/'libvamp-*.a '$(PREFIX)/$(TARGET)/lib/' \
    $(else), \
        $(foreach LIB, libvamp-hostsdk.a libvamp-sdk.a, \
            $(MAKE_SHARED_FROM_STATIC) '$(1)/$(LIB)' --ld '$(TARGET)-g++' LIBS=-lz;) \
    )
endef
