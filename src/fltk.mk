# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# FLTK
PKG             := fltk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.0
$(PKG)_CHECKSUM := 720f2804be6132ebae9909d4e74dedcc00b39d25
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR)-source.tar.gz
$(PKG)_WEBSITE  := http://www.fltk.org/
$(PKG)_URL      := http://ftp.easysw.com/pub/fltk/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg libpng pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://www.fltk.org/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    grep -v '^1\.1\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    $(SED) -i 's,\$$uname,MINGW,g' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads \
        LIBS='-lws2_32'
    # enable exceptions, because disabling them doesn't make any sense on PCs
    $(SED) -i 's,-fno-exceptions,,' '$(1)/makeinclude'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DIRS=src LIBCOMMAND='$(TARGET)-ar cr'
    ln -sf '$(PREFIX)/$(TARGET)/bin/fltk-config' '$(PREFIX)/bin/$(TARGET)-fltk-config'
    
    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic -ansi \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-fltk.exe' \
        `$(TARGET)-fltk-config --cxxflags --ldstaticflags`
endef
