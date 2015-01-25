# This file is part of MXE.
# See index.html for further information.

PKG             := stimfit
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.13.17windows
$(PKG)_CHECKSUM := f79caaa21eedead1f3719be732f4fb9b6056116a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/neurodroid/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc biosig wxwidgets hdf5 boost fftw

define $(PKG)_UPDATE
    wget -q -O- 'https://github.com/neurodroid/stimfit/releases' | \
    $(SED) -n 's_.*<a href="/neurodroid/stimfit/tree/\([0-9\.]*\)\.tar\.gz.*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

    rm -rf '$(1)'
    cp -r ~/src/stimfit '$(1)'
    -WXCONF='$(PREFIX)/bin/$(TARGET)-wx-config' $(MAKE) -C '$(1)' -f Makefile.static clean

    cd '$(1)' && ./autogen.sh && ./configure --enable-python --with-biosig --with-pslope
    WXCONF='$(PREFIX)/bin/$(TARGET)-wx-config' $(MAKE) -C '$(1)' -f Makefile.static -j '$(JOBS)'

    $(INSTALL) '$(1)/stimfit.exe' '$(PREFIX)/$(TARGET)/bin/'

    -$(INSTALL) '$(1)/stimfit.exe' /fs3/group/jonasgrp/Software/Stimfit/stimfit.$(TARGET).$(shell date +%Y%m%d).exe
    -(cd /fs3/group/jonasgrp/Software/Stimfit && ln -sf stimfit.$(TARGET).$(shell date +%Y%m%d).exe stimfit.$(TARGET).LATEST.exe)

    #-cd /fs3/group/jonasgrp/Software/Stimfit && ln -sf stimfit.$(TARGET).$(shell date +%Y%m%d).exe stimfit.$(shell date +%Y%m%d).exe


endef

