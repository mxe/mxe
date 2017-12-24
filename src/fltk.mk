# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fltk
$(PKG)_WEBSITE  := http://www.fltk.org/
$(PKG)_DESCR    := FLTK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.3
$(PKG)_CHECKSUM := f8398d98d7221d40e77bc7b19e761adaf2f1ef8bb0c30eceb7beb4f2273d0d97
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR)-source.tar.gz
$(PKG)_URL      := http://fltk.org/pub/fltk/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg libpng pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.fltk.org/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    grep -v '^1\.1\.' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,\$$uname,MINGW,g' '$(1)/configure'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        LIBS='-lws2_32'
    # enable exceptions, because disabling them doesn't make any sense on PCs
    $(SED) -i 's,-fno-exceptions,,' '$(1)/makeinclude'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DIRS=src LIBCOMMAND='$(TARGET)-ar cr'
    ln -sf '$(PREFIX)/$(TARGET)/bin/fltk-config' '$(PREFIX)/bin/$(TARGET)-fltk-config'

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-fltk.exe' \
        `$(TARGET)-fltk-config --cxxflags --ld$(if $(BUILD_STATIC),static)flags`
endef
