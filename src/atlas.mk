# This file is part of MXE.
# See index.html for further information.

PKG             := atlas
$(PKG)_VERSION  := 3.10.1
$(PKG)_CHECKSUM := cd5bfb06af3de60de1226078a9247684b44d0451
$(PKG)_SUBDIR   := ATLAS
$(PKG)_FILE     := $(PKG)$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/math-atlas/Stable/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/math-atlas/files/Stable/' | \
    $(SED) -n 's,.*<a href="/projects/math-atlas/files/Stable/\([0-9.]*\)\/">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD

    mkdir '$(1)/build'

echo '$(PREFIX)/$(TARGET)/bin/ar'        > build/MinGW32.dat
echo '$(PREFIX)/$(TARGET)/bin/ranlib'   >> build/MinGW32.dat
echo '$(PREFIX)/$(TARGET)/bin/gcc'      >> build/MinGW32.dat
echo '$(PREFIX)/$(TARGET)/bin/gfortran' >> build/MinGW32.dat

    cd '$(1)/build' && ./configure \
        -b 32 \
        -Si nocygwin 1 \
        --shared \
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
