# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# POCO C++ Libraries
PKG             := poco
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.1
$(PKG)_PATCHNUM := p1
$(PKG)_CHECKSUM := e9810b8fc14c607626d7d3c74baf60726a61e83c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)$($(PKG)_PATCHNUM)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)$($(PKG)_PATCHNUM).tar.gz
$(PKG)_WEBSITE  := http://sourceforge.net/projects/$(PKG)/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/poco/sources/poco-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --config=MinGW-CrossEnv \
        --static \
        --prefix='$(PREFIX)/$(TARGET)' 
    $(MAKE) -C '$(1)' -j '$(JOBS)' install 

    '$(TARGET)-g++' -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-poco.exe' -lPocoFoundation
endef
