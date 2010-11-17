# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# tinyxml
PKG             := tinyxml
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.1
$(PKG)_CHECKSUM := 2ff9c177a6c0bef10cbd27700b71826801c12987
$(PKG)_SUBDIR   := $(PKG)
$(PKG)_FILE     := $(PKG)_$(subst .,_,$($(PKG)_VERSION)).tar.gz
$(PKG)_WEBSITE  := http://sourceforge.net/projects/$(PKG)/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/tinyxml/files/tinyxml/) | \
    $(SED) -n 's,.*tinyxml_\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(TARGET)-g++ -c -O3 -Wall -Wno-unknown-pragmas -Wno-format -D TIXML_USE_STL '$(1)'/*.cpp
    cd '$(1)' && $(TARGET)-ar cr libtinyxml.a *.o
    $(TARGET)-ranlib '$(1)/libtinyxml.a'
    $(INSTALL) -d               '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)'/*.a '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d               '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)'/*.h '$(PREFIX)/$(TARGET)/include/'

    '$(TARGET)-g++' \
        -W -Wall -D TIXML_USE_STL -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-tinyxml.exe' \
        -ltinyxml
endef
