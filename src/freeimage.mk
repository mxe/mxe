# This file is part of MXE.
# See index.html for further information.

PKG             := freeimage
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.15.4
$(PKG)_CHECKSUM := eb6361519d33131690a0e726b085a05825e5adf9fb72c752d8d39100e48dc829
$(PKG)_SUBDIR   := FreeImage
$(PKG)_FILE     := FreeImage$(subst .,,$($(PKG)_VERSION)).zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeimage/Source Distribution/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/freeimage/files/Source Distribution/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' -f Makefile.mingw \
        CXX='$(TARGET)-g++' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        RC='$(TARGET)-windres' \
        FREEIMAGE_LIBRARY_TYPE=STATIC \
        TARGET=freeimage

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libfreeimage.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/Source/FreeImage.h' '$(PREFIX)/$(TARGET)/include/'

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: freeimage'; \
     echo 'Version: $(freeimage_VERSION)'; \
     echo 'Description: FreeImage'; \
     echo 'Cflags: -DFREEIMAGE_LIB'; \
     echo 'Libs: -lfreeimage -lws2_32 -lstdc++';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/freeimage.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-freeimage.exe' \
        `'$(TARGET)-pkg-config' freeimage --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
