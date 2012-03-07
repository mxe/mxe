# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# gta
PKG             := gta
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2
$(PKG)_CHECKSUM := 9020944bcd40bd986a879d454d21920a1eb48db7
$(PKG)_SUBDIR   := libgta-$($(PKG)_VERSION)
$(PKG)_FILE     := libgta-$($(PKG)_VERSION).tar.xz
$(PKG)_WEBSITE  := http://gta.nongnu.org/
$(PKG)_URL      := http://download.savannah.gnu.org/releases/gta/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 xz

define $(PKG)_UPDATE
    wget -q -O- 'http://git.savannah.gnu.org/gitweb/?p=gta.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>libgta-\([0-9.]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --disable-reference \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install dist_doc_DATA=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gta.exe' \
        `'$(TARGET)-pkg-config' gta --cflags --libs`
endef
