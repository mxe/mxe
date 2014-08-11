# This file is part of MXE.
# See index.html for further information.

PKG             := assimp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0
$(PKG)_VERBUILD := 3.0.1270
$(PKG)_CHECKSUM := e80a3a4326b649ed6585c0ce312ed6dd68942834
$(PKG)_SUBDIR   := $(PKG)--$($(PKG)_VERBUILD)-source-only
$(PKG)_FILE     := $(PKG)--$($(PKG)_VERBUILD)-source-only.zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://sourceforge.net/projects/assimp/files/" | \
    grep 'assimp/files' | \
    $(SED) -n 's,.*assimp-\([0-9][^>]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_ASSIMP_TOOLS=OFF \
        -DBUILD_ASSIMP_SAMPLES=OFF
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-assimp.exe' \
        `'$(TARGET)-pkg-config' assimp --cflags --libs`
endef
