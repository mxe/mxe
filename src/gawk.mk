# This file is part of MXE.
# See index.html for further information.

PKG             := gawk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.0
$(PKG)_CHECKSUM := 1d5bf6feca1228550b9c5d0b223ddc53ffc39c19
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := gawk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package gawk.' >&2;
    echo $(gnuplot_VERSION)
endef

define $(PKG)_BUILD
     mkdir '$(1).build'
     cd  '$(1).build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'

     $(MAKE) -C '$(1).build' -j '$(JOBS)'

     $(INSTALL) '$(1).build'/gawk '$(PREFIX)/$(TARGET)/bin/gawk.exe'

endef

$(PKG)_BUILD_i686-pc-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =

