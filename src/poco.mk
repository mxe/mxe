# This file is part of MXE.
# See index.html for further information.

PKG             := poco
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c89833d208cc6a3b54a239a776dcb611e7cd4b02
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/sources/$(PKG)-$(word 1,$(subst p, ,$($(PKG)_VERSION)))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://pocoproject.org/download/' | \
    $(SED) -n 's,.*poco-\([0-9][^>/]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --config=MinGW-CrossEnv \
        --static \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install CROSSENV=$(TARGET)

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-poco.exe' \
        -lPocoFoundation
endef
