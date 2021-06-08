# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fltk
$(PKG)_WEBSITE  := https://www.fltk.org/
$(PKG)_DESCR    := FLTK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.6
$(PKG)_CHECKSUM := 9aac75ef9e9b7bd7b5338a4c0d4dd536e6c22ea7b15ea622aa1d8f1fa30d37ab
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_MAJOR    := $(word 1,$(subst -, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := $($(PKG)_SUBDIR)-source.tar.gz
$(PKG)_URL      := https://fltk.org/pub/fltk/$($(PKG)_MAJOR)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg libpng pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.fltk.org/software.php' | \
    $(SED) -n 's,.*>fltk-\([0-9]\+\([\.\-][0-9]\+\)\+\)-source\.tar\.gz<.*,\1,p' | \
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
