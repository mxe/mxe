# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# FLTK
PKG             := fltk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.10
$(PKG)_CHECKSUM := 0d2b34fede91fa78eeaefb893dd70282f73908a8
$(PKG)_SUBDIR   := fltk-$($(PKG)_VERSION)
$(PKG)_FILE     := fltk-$($(PKG)_VERSION)-source.tar.bz2
$(PKG)_WEBSITE  := http://www.fltk.org/
$(PKG)_URL      := http://ftp.easysw.com/pub/fltk/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg libpng pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://www.fltk.org/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,\$$uname,MINGW,g' '$(1)/configure'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads \
        LIBS='-lws2_32'
    $(SED) -i 's,-fno-exceptions,,' '$(1)/makeinclude'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DIRS=src LIBCOMMAND='$(TARGET)-ar cr'
endef
