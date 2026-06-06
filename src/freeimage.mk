# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := freeimage
$(PKG)_WEBSITE  := https://freeimage.sourceforge.io/
$(PKG)_DESCR    := FreeImage
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.18.0
$(PKG)_CHECKSUM := f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd
$(PKG)_SUBDIR   := FreeImage
$(PKG)_FILE     := FreeImage$(subst .,,$($(PKG)_VERSION)).zip
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/freeimage/Source Distribution/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/freeimage/files/Source Distribution/' | \
    $(SED) -n 's,.*Distribution/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_STATIC
    $(SED) -i '1i #include <string.h>' '$(1)/Source/OpenEXR/IlmImf/ImfAutoArray.h'
    $(SED) -i 's/^CXXFLAGS ?=.*/CXXFLAGS ?= -std=c++14 -Wno-narrowing -O3 -fexceptions -Wno-ctor-dtor-privacy -DNDEBUG $$(WIN32_CXXFLAGS)/' '$(1)/Makefile.mingw'
    $(SED) -i 's/^CXXFLAGS ?=.*/CXXFLAGS ?= -std=c++14 -Wno-narrowing -O3 -fPIC -fexceptions -fvisibility=hidden -Wno-ctor-dtor-privacy -DFREEIMAGE_LIB/' '$(1)/Makefile.fip'

    $(MAKE) -C '$(1)' -j '$(JOBS)' -f Makefile.mingw \
        CXX='$(TARGET)-g++' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        RC='$(TARGET)-windres' \
        FREEIMAGE_LIBRARY_TYPE=STATIC \
        TARGET=freeimage

    $(MAKE) -C '$(1)' -j '$(JOBS)' -f Makefile.fip \
        CXX='$(TARGET)-g++' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        RC='$(TARGET)-windres' \
        libfreeimageplus.a

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libfreeimage.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libfreeimageplus.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/Source/FreeImage.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/Wrapper/FreeImagePlus/FreeImagePlus.h' '$(PREFIX)/$(TARGET)/include/'

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: freeimage'; \
     echo 'Version: $(freeimage_VERSION)'; \
     echo 'Description: FreeImage'; \
     echo 'Cflags: -DFREEIMAGE_LIB'; \
     echo 'Libs: -lfreeimage -lws2_32 -lstdc++';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/freeimage.pc'
    (echo 'Name: freeimageplus'; \
     echo 'Version: $(freeimage_VERSION)'; \
     echo "Description: FreeImagePlus"; \
     echo 'Cflags: -DFREEIMAGE_LIB'; \
     echo 'Libs: -lfreeimage -lfreeimageplus -lws2_32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/freeimageplus.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-freeimage.exe' \
        `'$(TARGET)-pkg-config' freeimage --cflags --libs`

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-freeimageplus.exe' \
        `'$(TARGET)-pkg-config' freeimageplus --cflags --libs`
endef

define $(PKG)_BUILD_SHARED
    $(SED) -i '1i #include <string.h>' '$(1)/Source/OpenEXR/IlmImf/ImfAutoArray.h'
    $(SED) -i 's/^CXXFLAGS ?=.*/CXXFLAGS ?= -std=c++14 -Wno-narrowing -O3 -fexceptions -Wno-ctor-dtor-privacy -DNDEBUG $$(WIN32_CXXFLAGS)/' '$(1)/Makefile.mingw'
    $(SED) -i 's/^CXXFLAGS ?=.*/CXXFLAGS ?= -std=c++14 -Wno-narrowing -O3 -fPIC -fexceptions -fvisibility=hidden -Wno-ctor-dtor-privacy -DFREEIMAGE_LIB/' '$(1)/Makefile.fip'
    $(SED) -i 's,-shared -static,-shared,' '$(1)/Makefile.mingw'
    $(MAKE) -C '$(1)' -j '$(JOBS)' -f Makefile.mingw \
        CXX='$(TARGET)-g++' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        RC='$(TARGET)-windres' \
        DLLTOOL='$(TARGET)-dlltool' \
        LD='$(TARGET)-g++' \
        FREEIMAGE_LIBRARY_TYPE=SHARED \
        SHAREDLIB=libfreeimage.dll \
        IMPORTLIB=libfreeimage.dll.a \
        TARGET=freeimage


    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libfreeimage.dll.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) -m644 '$(1)/libfreeimage.dll' '$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/Source/FreeImage.h' '$(PREFIX)/$(TARGET)/include/'

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: freeimage'; \
     echo 'Version: $(freeimage_VERSION)'; \
     echo 'Description: FreeImage'; \
     echo 'Libs: -lfreeimage -lws2_32 -lstdc++';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/freeimage.pc'
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-freeimage.exe' \
        `'$(TARGET)-pkg-config' freeimage --cflags --libs`
endef
