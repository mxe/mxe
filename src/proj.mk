# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := proj
$(PKG)_WEBSITE  := https://trac.osgeo.org/proj/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.8.1
$(PKG)_CHECKSUM := af5b731c145c1d13c4e3b4eeb7d167e94e845e440f71e3496b4ed8dae0291960
$(PKG)_SUBDIR   := proj-$($(PKG)_VERSION)
$(PKG)_FILE     := proj-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://download.osgeo.org/proj/$($(PKG)_FILE)
$(PKG)_DEPS     := cc sqlite curl tiff

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.osgeo.org/proj/' | \
    $(SED) -n 's,.*title="proj-\([0-9.]\+\)\.tar\.gz".*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-cmake' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DCMAKE_VERBOSE_MAKEFILE=ON \
        -DENABLE_CURL=ON \
        -DCMAKE_C_FLAGS="`'$(TARGET)-pkg-config' libcurl --cflags`" \
        -DCMAKE_CXX_FLAGS="`'$(TARGET)-pkg-config' libcurl --cflags`" \
        -DMXE_CURL_LIBS:STRING="`'$(TARGET)-pkg-config' libcurl --libs`"
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    $(if $(BUILD_SHARED),
        mv '$(PREFIX)/$(TARGET)/lib/libproj.dll.a' '$(PREFIX)/$(TARGET)/lib/libproj.a')

    # Build test script
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef

