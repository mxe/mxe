# This file is part of MXE.
# See index.html for further information.

PKG             := portmidi
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f45bf4e247c0d7617deacd6a65d23d9fddae6117
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
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=STATIC

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' portmidi-static

    # install library files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/build/libportmidi_s.a' \
                     '$(PREFIX)/$(TARGET)/lib/libportmidi.a'

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
