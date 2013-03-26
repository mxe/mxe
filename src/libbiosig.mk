# This file is part of MXE.
# See index.html for further information.

PKG             := libbiosig
$(PKG)_IGNORE   := 
$(PKG)_CHECKSUM := f44cd207201bb7ae6afbf647812cacc4f1bc1814
$(PKG)_SUBDIR   := biosig4c++-$($(PKG)_VERSION)
$(PKG)_FILE     := biosig4c++-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/biosig/files/BioSig%20for%20C_C%2B%2B/src/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc suitesparse zlib libgomp libiberty libiconv

define $(PKG)_UPDATE
#    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
#    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD


    # make sure NDEBUG is defined 
    $(SED) -i '/NDEBUG/ s|^#*||g' '$(1)'/Makefile 

    TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' io.h libbiosig.a libbiosig2.a libgdf.a save2gdf libphysicalunits.a

    $(INSTALL) -m644 '$(1)'/save2gdf           '$(PREFIX)/$(TARGET)/bin/save2gdf.exe'

    $(INSTALL) -m644 '$(1)/biosig.h'           '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/libbiosig.a'        '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libgdf.a'           '$(PREFIX)/$(TARGET)/lib/'

    $(INSTALL) -m644 '$(1)/biosig2.h'          '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/libbiosig2.a'       '$(PREFIX)/$(TARGET)/lib/'

    $(INSTALL) -m644 '$(1)/physicalunits.h'    '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.a' '$(PREFIX)/$(TARGET)/lib/'

endef

