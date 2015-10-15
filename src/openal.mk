# This file is part of MXE.
# See index.html for further information.

PKG             := openal
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16.0
$(PKG)_CHECKSUM := 2f3dcd313fe26391284fbf8596863723f99c65d6c6846dccb48e79cadaf40d5f
$(PKG)_SUBDIR   := openal-soft-$($(PKG)_VERSION)
$(PKG)_FILE     := openal-soft-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://kcat.strangesoft.net/openal-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc portaudio

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://kcat.strangesoft.net/openal-releases/?C=M;O=D' | \
    $(SED) -n 's,.*"openal-soft-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=$(if $(BUILD_SHARED),SHARED,STATIC) \
        -DEXAMPLES=FALSE \
        -DALSOFT_UTILS=FALSE
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-openal.exe' \
        `'$(TARGET)-pkg-config' openal --cflags --libs`
endef
