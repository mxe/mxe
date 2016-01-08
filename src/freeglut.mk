# This file is part of MXE.
# See index.html for further information.

PKG             := freeglut
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.1
$(PKG)_CHECKSUM := dde46626a62a1cd9cf48a11951cdd592e7067c345cffe193a149dfd47aef999a
$(PKG)_SUBDIR   := freeglut-$(word 1,$(subst -, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := freeglut-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeglut/freeglut/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/freeglut/files/freeglut/' | \
    $(SED) -n 's,.*freeglut-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-replace-glut \
        --disable-debug \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= $(if $(BUILD_STATIC),EXPORT_FLAGS='-DFREEGLUT_STATIC')

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-freeglut.exe' \
        `'$(TARGET)-pkg-config' glut --cflags --libs`
endef
