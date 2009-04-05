# FLTK

PKG             := fltk
$(PKG)_VERSION  := 1.1.9
$(PKG)_CHECKSUM := 6f21903dc53c829ec71e8e49655eb19e624c8247
$(PKG)_SUBDIR   := fltk-$($(PKG)_VERSION)
$(PKG)_FILE     := fltk-$($(PKG)_VERSION)-source.tar.bz2
$(PKG)_WEBSITE  := http://www.fltk.org/
$(PKG)_URL      := http://ftp.easysw.com/pub/fltk/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads zlib jpeg libpng

define $(PKG)_UPDATE
    wget -q -O- 'http://www.fltk.org/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,\$$uname,MINGW,g' -i '$(1)/configure'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads \
        LIBS='-lws2_32'
    $(SED) 's,-fno-exceptions,,' -i '$(1)/makeinclude'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DIRS=src LIBCOMMAND='$(TARGET)-ar cr'
endef
