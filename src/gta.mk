# This file is part of MXE.
# See index.html for further information.

PKG             := gta
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.5
$(PKG)_CHECKSUM := 7fdca4a37c6f1617952c69b5aac370fed2f00e41
$(PKG)_SUBDIR   := libgta-$($(PKG)_VERSION)
$(PKG)_FILE     := libgta-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://download.savannah.gnu.org/releases/gta/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 xz

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/gitweb/?p=gta.git;a=tags' | \
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
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gta.exe' \
        `'$(TARGET)-pkg-config' gta --cflags --libs`
endef

