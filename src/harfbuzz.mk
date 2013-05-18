# This file is part of MXE.
# See index.html for further information.

PKG             := harfbuzz
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 2f33c388a0be3d07fda58201890d8a9f54a9e7ee
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.freedesktop.org/software/$(PKG)/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib cairo freetype icu4c

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cgit.freedesktop.org/harfbuzz/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '^1\.[01234]\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --enable-static
    $(MAKE) -C '$(1)/src'      -j '$(JOBS)'
    # some of these tests want to be linked with g++
    # but there's no easy way to bypass the am__v_CCLD... logic
    $(MAKE) -C '$(1)/test/api' -j '$(JOBS)' test-blob.exe test-buffer.exe test-common.exe test-ot-tag.exe test-set.exe test-version.exe
    $(MAKE) -C '$(1)/test/api' -j '$(JOBS)' || $(MAKE) -C '$(1)/test/api' -j '$(JOBS)' CC=$(TARGET)-g++
    $(MAKE) -C '$(1)' install
endef
