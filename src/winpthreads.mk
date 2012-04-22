# This file is part of MXE.
# See index.html for further information.

PKG             := winpthreads
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 85270b3509b7e0eb3354230e81663f7904a58707
$(PKG)_SUBDIR   := winpthreads-$($(PKG)_VERSION)
$(PKG)_FILE     := winpthreads-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/downloads/tonytheodore/mxe/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package winpthreads.' >&2;
    echo $(winpthreads_VERSION)
endef

define $(PKG)_BUILD_x86_64-static-mingw32
    cd '$(1)' && ./configure \
        $(LINK_STYLE) \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TOP_DIR)/src/pthreads-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-pthreads.exe' \
        -lpthread -lws2_32
endef
