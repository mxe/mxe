# This file is part of MXE.
# See index.html for further information.

PKG             := gawk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.4
$(PKG)_CHECKSUM := 53e184e2d0f90def9207860531802456322be091c7b48f23fdc79cda65adc266
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := gawk-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://ftp.gnu.org/gnu/gawk/?C=M;O=D" | \
    $(SED) -n 's,.*a href="gawk-\([0-9.]*\).tar.gz.*,\1,p' | \
    head -1
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

