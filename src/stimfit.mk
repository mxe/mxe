# This file is part of MXE.
# See index.html for further information.

PKG             := stimfit
$(PKG)_IGNORE   := 
$(PKG)_CHECKSUM := 61d3cbf049468b6a714acc5a6f451945c9d3f0a8
$(PKG)_SUBDIR   := stimfit-$($(PKG)_VERSION)
$(PKG)_FILE     := stimfit-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://stimfit.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libbiosig wxwidgets hdf5 boost fftw

define $(PKG)_UPDATE
#    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
#    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip' | \
     (cd $(HOME)/src/stimfit/ && git log | head -1)
endef

define $(PKG)_BUILD

    ## The patch did not apply cleanly, so -DWITH_HDF4 needs to be defined	
    WXCONF='$(PREFIX)/bin/$(TARGET)-wx-config' $(MAKE) -C '$(1)' -f Makefile.static -j '$(JOBS)'

    $(INSTALL) -m644 '$(1)/stimfit.exe' '$(PREFIX)/$(TARGET)/bin/'

endef

