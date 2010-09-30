# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# openal
PKG             := openal
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12.854
$(PKG)_CHECKSUM := 537dc5fad32d227bb5e861506018b46a21e47f26
$(PKG)_SUBDIR   := openal-soft-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_WEBSITE  := http://kcat.strangesoft.net/openal.html
$(PKG)_URL      := http://kcat.strangesoft.net/openal-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://kcat.strangesoft.net/openal-releases/' | \
    $(SED) -n 's,.*openal-soft-\([0-9][^<]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)/build' && cmake ..                            \
        -DCMAKE_SYSTEM_NAME=Windows                        \
        -DCMAKE_FIND_ROOT_PATH='$(PREFIX)/$(TARGET)'       \
        -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER          \
        -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY           \
        -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY           \
        -DCMAKE_C_COMPILER='$(PREFIX)/bin/$(TARGET)-gcc'   \
        -DCMAKE_CXX_COMPILER='$(PREFIX)/bin/$(TARGET)-gcc' \
        -DCMAKE_INCLUDE_PATH='$(PREFIX)/$(TARGET)/include' \
        -DCMAKE_LIB_PATH='$(PREFIX)/$(TARGET)/lib'         \
        -DPKG_CONFIG_EXECUTABLE=$(TARGET)-pkg-config       \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)'       \
        -DCMAKE_BUILD_TYPE=Release                         \
        -DLIBTYPE=STATIC
    cd '$(1)/build' && $(MAKE) -j '$(JOBS)'
    cd '$(1)/build' && cp -fv  OpenAL32.a $(PREFIX)/$(TARGET)/lib/libOpenAL32.a
    cd '$(1)/build' && cp -rfv openal.pc  $(PREFIX)/$(TARGET)/lib/pkgconfig
    $(SED) -i 's,^\(Libs:.*\),\1 -lwinmm,' $(PREFIX)/$(TARGET)/lib/pkgconfig/openal.pc
    cd '$(1)' && cp -rfv include/*  $(PREFIX)/$(TARGET)/include
endef
