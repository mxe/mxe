# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gta
$(PKG)_WEBSITE  := http://www.nongnu.org/gta/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.8
$(PKG)_CHECKSUM := 1d2ff713955eee28310de082a8fd8e236403c27dee3716ba1238c56e6643e4fb
$(PKG)_SUBDIR   := libgta-$($(PKG)_VERSION)
$(PKG)_FILE     := libgta-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.savannah.gnu.org/releases/gta/$($(PKG)_FILE)
$(PKG)_DEPS     := cc bzip2 xz zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.savannah.gnu.org/gitweb/?p=gta.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>libgta-\([0-9.]*\)<.*,\1,p' | \
    head -1

endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-reference
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install dist_doc_DATA=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-gta.exe' \
        `'$(TARGET)-pkg-config' gta --cflags --libs`
endef
