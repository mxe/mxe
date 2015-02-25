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
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),FALSE,TRUE) \
        -DCMAKE_CXX_FLAGS='-DTIXML_USE_STL' \
        '$(1)'
    $(MAKE) -C '$(1).build' -j $(JOBS) install

    '$(TARGET)-g++' \
        -W -Wall -DTIXML_USE_STL -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-tinyxml.exe' \
        -ltinyXML
endef
