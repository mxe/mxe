# This file is part of MXE.
# See index.html for further information.

PKG             := stimfit
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.13.10windows
$(PKG)_CHECKSUM := caf318ea945ee55daf79ba49ecdb39caf2e52c5c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/neurodroid/$(PKG)/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc biosig wxwidgets hdf5 boost fftw

define $(PKG)_UPDATE
    wget -q -O- 'https://github.com/neurodroid/stimfit/releases' | \
    $(SED) -n 's_.*<a href="/neurodroid/stimfit/tree/\([0-9\.]*\)\.tar\.gz.*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

    cd '$(1)' && ./autogen.sh && ./configure --enable-python --with-biosig --with-pslope
    WXCONF='$(PREFIX)/bin/$(TARGET)-wx-config' $(MAKE) -C '$(1)' -f Makefile.static -j '$(JOBS)'

    $(INSTALL) '$(1)/stimfit.exe' '$(PREFIX)/$(TARGET)/bin/'

endef

