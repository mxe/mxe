# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# jpeg
PKG             := jpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8d
$(PKG)_CHECKSUM := f080b2fffc7581f7d19b968092ba9ebc234556ff
$(PKG)_SUBDIR   := jpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := jpegsrc.v$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.ijg.org/
$(PKG)_URL      := http://www.ijg.org/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.ijg.org/' | \
    $(SED) -n 's,.*jpegsrc\.v\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-jpeg.exe' \
        -ljpeg
endef
