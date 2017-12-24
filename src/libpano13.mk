# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libpano13
$(PKG)_WEBSITE  := https://panotools.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9.18
$(PKG)_CHECKSUM := de5d4e43f15c3430e95c0faa1c50c9503516e1b570d0ec0522f610a578caa172
$(PKG)_SUBDIR   := $(PKG)-$(word 1,$(subst _, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/panotools/$(PKG)/$($(PKG)_SUBDIR)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg libpng tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/api/file/index/project-id/96188/rss?path=/libpano13' | \
    $(SED) -n 's,.*libpano13-\([0-9].*\)\.tar.*,\1,p' | \
    grep -v beta | \
    grep -v rc | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,WINDOWSX\.H,windowsx.h,'                                                  '$(1)/sys_win.h'
    $(SED) -i 's,\$${WINDRES-windres},$(TARGET)-windres,'                                  '$(1)/build/win32/compile-resource'
    $(SED) -i 's,m4 -DBUILDNUMBER=\$$buildnumber,$(SED) "s/BUILDNUMBER/\$$buildnumber/g",' '$(1)/build/win32/compile-resource'
    $(SED) -i 's,\(@HAVE_MINGW_TRUE@am__objects_4 = .*\),\1 ppm.lo,'                       '$(1)/Makefile.in'
    $(SED) -i 's,\(@HAVE_MINGW_TRUE@WIN_SRC = .*\),\1 ppm.c,'                              '$(1)/Makefile.in'
    $(SED) -i 's,mv.*libpano13\.dll.*,,'                                                   '$(1)/Makefile.in'
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --with-jpeg='$(PREFIX)/$(TARGET)'/lib \
        --with-tiff='$(PREFIX)/$(TARGET)'/lib \
        --with-png='$(PREFIX)/$(TARGET)'/lib \
        --with-zlib='$(PREFIX)/$(TARGET)'/lib \
        LIBS="`'$(TARGET)-pkg-config' --libs libtiff-4`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef

$(PKG)_BUILD_SHARED =
