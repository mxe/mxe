# This file is part of MXE.
# See index.html for further information.

PKG             := stimfit
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.12.9
$(PKG)_CHECKSUM := 2bb590aa4632055689e07652b6cc6a254d21aaa0
$(PKG)_SUBDIR   := stimfit-$($(PKG)_VERSION)
$(PKG)_FILE     := stimfit-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://stimfit.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc biosig wxwidgets hdf5 boost fftw

define $(PKG)_UPDATE
    wget -q -O- 'http://code.google.com/p/stimfit/downloads/list' | \
    $(SED) -n 's_.*name=stimfit-\([0-9\.]*\)\.tar\.gz.*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

    WXCONF='$(PREFIX)/bin/$(TARGET)-wx-config' $(MAKE) -C '$(1)' -f Makefile.static -j '$(JOBS)'

    $(INSTALL) '$(1)/stimfit.exe' '$(PREFIX)/$(TARGET)/bin/'

endef

