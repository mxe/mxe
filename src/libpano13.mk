# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# libpano13
PKG             := libpano13
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9.17_beta1
$(PKG)_CHECKSUM := d92238ca00e29b18f26dd86de7e1425ab8ff26a8
$(PKG)_SUBDIR   := libpano13-$(word 1,$(subst _, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := libpano13-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://panotools.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/panotools/libpano13/libpano13-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff libpng zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/api/file/index/project-id/96188/rss?path=/libpano13' | \
    grep '/download</link>' | \
    $(SED) -n 's,.*libpano13-\([0-9].*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) 's,WINDOWSX\.H,windowsx.h,'                                                  -i '$(1)/sys_win.h'
    $(SED) 's,\$${WINDRES-windres},$(TARGET)-windres,'                                  -i '$(1)/build/win32/compile-resource'
    $(SED) 's,m4 -DBUILDNUMBER=\$$buildnumber,$(SED) "s/BUILDNUMBER/\$$buildnumber/g",' -i '$(1)/build/win32/compile-resource'
    $(SED) 's,mv.*libpano13\.dll.*,,'                                                   -i '$(1)/Makefile.in'
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --with-jpeg='$(PREFIX)/$(TARGET)'/lib \
        --with-tiff='$(PREFIX)/$(TARGET)'/lib \
        --with-png='$(PREFIX)/$(TARGET)'/lib \
        --with-zlib='$(PREFIX)/$(TARGET)'/lib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
