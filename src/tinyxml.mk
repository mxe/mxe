# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# tinyxml
PKG             := tinyxml
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2_6_1
$(PKG)_CHECKSUM := 2ff9c177a6c0bef10cbd27700b71826801c12987
$(PKG)_SUBDIR   := tinyxml
$(PKG)_FILE     := tinyxml_$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://sourceforge.net/projects/tinyxml/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/tinyxml/tinyxml/$(subst _,.,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/tinyxml/files/tinyxml/) | \
    $(SED) -n 's,.*tinyxml_\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
    $(TARGET)-g++ -c -O3 -Wall -Wno-unknown-pragmas -Wno-format -D TIXML_USE_STL -o tinyxml.o tinyxml.cpp && \
    $(TARGET)-g++ -c -O3 -Wall -Wno-unknown-pragmas -Wno-format -D TIXML_USE_STL -o tinyxmlparser.o tinyxmlparser.cpp && \
    $(TARGET)-g++ -c -O3 -Wall -Wno-unknown-pragmas -Wno-format -D TIXML_USE_STL -o tinyxmlerror.o tinyxmlerror.cpp && \
    $(TARGET)-g++ -c -O3 -Wall -Wno-unknown-pragmas -Wno-format -D TIXML_USE_STL -o tinystr.o tinystr.cpp && \
    $(TARGET)-g++ -c -O3 -Wall -Wno-unknown-pragmas -Wno-format -D TIXML_USE_STL -o tinyxmlerror.o tinyxmlerror.cpp && \
    $(TARGET)-ar cr libtinyxml.a tinystr.o tinyxmlerror.o tinyxml.o tinyxmlparser.o
    $(TARGET)-ranlib '$(1)/libtinyxml.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libtinyxml.a' '$(PREFIX)/$(TARGET)/lib/libtinyxml.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/tinyxml.h' '$(1)/tinystr.h' '$(PREFIX)/$(TARGET)/include/'

    '$(TARGET)-g++' \
        -W -Wall -D TIXML_USE_STL -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-tinyxml.exe' \
        -I'$(PREFIX)/$(TARGET)/include/' -ltinyxml
endef
