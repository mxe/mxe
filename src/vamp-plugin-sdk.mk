# This file is part of MXE.
# See index.html for further information.

PKG             := vamp-plugin-sdk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5
$(PKG)_CHECKSUM := e87292c5d02f4c562e269188c43500958b0ea65a
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
        DYNAMIC_LDFLAGS='-static-libgcc -shared -Wl,-Bsymbolic' \
        sdk$(if $(BUILD_STATIC),static)

    for f in vamp vamp-sdk vamp-hostsdk; do \
        $(SED) 's,%PREFIX%,$(PREFIX)/$(TARGET),' "$(1)/pkgconfig/$$f.pc.in" \
            > "$(PREFIX)/$(TARGET)/lib/pkgconfig/$$f.pc"; \
    done

    cp -rv '$(1)/vamp' '$(1)/vamp-hostsdk' '$(1)/vamp-sdk' '$(PREFIX)/$(TARGET)/include/'
    cp -rv '$(1)/'libvamp-*.$(LIB_SUFFIX) '$(PREFIX)/$(TARGET)/lib'
endef
