# This file is part of MXE.
# See index.html for further information.

PKG             := stimfit
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.13.2linux
$(PKG)_CHECKSUM := 21a4e45a68a2d296c6ca8ee22fc53a92c0ee1531
$(PKG)_SUBDIR   := stimfit-efab850f4f2d
$(PKG)_FILE     := $($(PKG)_VERSION).zip
$(PKG)_URL      := https://stimfit.googlecode.com/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc biosig wxwidgets hdf5 boost fftw

define $(PKG)_UPDATE
    wget -q -O- 'http://code.google.com/p/stimfit/downloads/list' | \
    $(SED) -n 's_.*name=stimfit-\([0-9\.]*\)\.tar\.gz.*_\1_ip' | \
    head -1
endef

## hack: because download from googlecode/archive/*.zip has varying checksums 
##    so we use the file size as a poor man's check
define $(PKG)_CHECK_PKG_ARCHIVE
     [[ `du -b pkg/$($(PKG)_FILE) | cut -f 1` = 14401795 ]]
endef

define $(PKG)_BUILD

    WXCONF='$(PREFIX)/bin/$(TARGET)-wx-config' $(MAKE) -C '$(1)' -f Makefile.static -j '$(JOBS)'

    $(INSTALL) '$(1)/stimfit.exe' '$(PREFIX)/$(TARGET)/bin/'

endef

