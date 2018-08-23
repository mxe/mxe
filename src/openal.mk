# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openal
$(PKG)_WEBSITE  := http://kcat.strangesoft.net/openal.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.18.2
$(PKG)_CHECKSUM := 9f8ac1e27fba15a59758a13f0c7f6540a0605b6c3a691def9d420570506d7e82
$(PKG)_SUBDIR   := openal-soft-$($(PKG)_VERSION)
$(PKG)_FILE     := openal-soft-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://kcat.strangesoft.net/openal-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc portaudio

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://kcat.strangesoft.net/openal-releases/?C=M;O=D' | \
    $(SED) -n 's,.*"openal-soft-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # Update OpenAL cross compilation script with mxe root path
    $(SED) -i "s|CMAKE_FIND_ROOT_PATH \"/usr/\$${HOST}\"|CMAKE_FIND_ROOT_PATH \"$(PREFIX)/$(TARGET)\"|" $(1)/XCompile.txt
    cat $(1)/XCompile.txt

    cd '$(1)/build' && '$(TARGET)-cmake' .. \
        -DHOST=$(TARGET) \
        -DCMAKE_TOOLCHAIN_FILE=../XCompile.txt \
        -DALSOFT_EXAMPLES=FALSE \
        -DALSOFT_UTILS=FALSE
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-openal.exe' \
        `'$(TARGET)-pkg-config' openal --cflags --libs`
endef
