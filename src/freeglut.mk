# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# freeglut
PKG             := freeglut
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.0
$(PKG)_CHECKSUM := 68306c4486c13d005a4e4d54035e0c0b1bdc220b
$(PKG)_SUBDIR   := freeglut-$(word 1,$(subst -, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := freeglut-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://freeglut.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeglut/freeglut/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/freeglut/files/freeglut/' | \
    $(SED) -n 's,.*freeglut-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,Windows\.h,windows.h,'   '$(1)/src/freeglut_internal.h'
    $(SED) -i 's,WindowsX\.h,windowsx.h,' '$(1)/src/freeglut_internal.h'
    $(SED) -i 's,MMSystem\.h,mmsystem.h,' '$(1)/src/freeglut_internal.h'
    $(SED) -i 's,Windows\.h,windows.h,'   '$(1)/include/GL/freeglut_std.h'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-replace-glut \
        --disable-debug \
        --without-progs \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
