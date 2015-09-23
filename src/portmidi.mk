# This file is part of MXE.
# See index.html for further information.

PKG             := portmidi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 217
$(PKG)_CHECKSUM := 08e9a892bd80bdb1115213fb72dc29a7bf2ff108b378180586aa65f3cfd42e0f
$(PKG)_SUBDIR   := portmidi
$(PKG)_FILE     := $(PKG)-src-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/portmedia/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://sourceforge.net/projects/portmedia/files/portmidi/" | \
    grep -i 'portmedia/files/portmidi' | \
    $(SED) -n 's,.*portmidi/\([0-9]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' portmidi-$(if $(BUILD_STATIC),static,dynamic)

    # install library files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(if $(BUILD_STATIC),                                             \
        $(INSTALL) -m644 '$(1)/build/libportmidi_s.a'                 \
                         '$(PREFIX)/$(TARGET)/lib/libportmidi.a',     \
        $(INSTALL) -m755 '$(1)/build/libportmidi.dll'                 \
                         '$(PREFIX)/$(TARGET)/bin/libportmidi.dll' && \
        $(INSTALL) -m644 '$(1)/build/libportmidi.dll.a'               \
                         '$(PREFIX)/$(TARGET)/lib/libportmidi.dll.a')

    # install include files
    $(INSTALL) -d                                '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/pm_common/portmidi.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/pm_common/pmutil.h'   '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/porttime/porttime.h'  '$(PREFIX)/$(TARGET)/include/'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-portmidi.exe' \
        -lportmidi -lwinmm
endef
