# This file is part of MXE.
# See index.html for further information.

PKG             := tinyxml
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.2
$(PKG)_CHECKSUM := cba3f50dd657cb1434674a03b21394df9913d764
$(PKG)_SUBDIR   := $(PKG)
$(PKG)_FILE     := $(PKG)_$(subst .,_,$($(PKG)_VERSION)).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/tinyxml/files/tinyxml/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
   cd '$(1)' && $(TARGET)-g++ -c -O3 -Wall -Wno-unknown-pragmas -Wno-format -D TIXML_USE_STL tiny*.cpp
    $(if $(BUILD_STATIC),
    $(TARGET)-ar cr libtinyxml.a *.o
    $(TARGET)-ranlib '$(1)/libtinyxml.a'
,
cd '$(1)' && $(TARGET)-g++ -shared -Wl,-soname,libtinyxml.so -o libtinyxml.so  *.o
)

    $(INSTALL) -d               '$(PREFIX)/$(TARGET)/lib'
    $(if $(BUILD_STATIC),
    $(INSTALL) -m644 '$(1)'/*.a '$(PREFIX)/$(TARGET)/lib/'
,
    $(INSTALL) -m644 '$(1)'/*.so '$(PREFIX)/$(TARGET)/lib/'
)
    $(INSTALL) -d               '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)'/*.h '$(PREFIX)/$(TARGET)/include/'

    '$(TARGET)-g++' \
        -W -Wall -D TIXML_USE_STL -ansi -pedantic \
        '$(1)/xmltest.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-tinyxml.exe' \
        -ltinyxml
endef



$(PKG)_BUILD_SHARED = $(subst .a , .so ,\
                      $($(PKG)_BUILD))
