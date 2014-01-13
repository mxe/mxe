# This file is part of MXE.
# See index.html for further information.

PKG             := biosig
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 1.5.10
$(PKG)_CHECKSUM := 3f4062426ff8e260c20c2726d6bd6e6cb9547498
$(PKG)_SUBDIR   := biosig4c++-$($(PKG)_VERSION)
$(PKG)_FILE     := biosig4c++-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/biosig/files/BioSig%20for%20C_C%2B%2B/src/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc suitesparse zlib libgomp libiberty libiconv

define $(PKG)_UPDATE
#    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
#    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD_PRE

    #rm -rf '$(1)'
    #cp -rL ~/src/biosig-code/biosig4c++ '$(1)'

    # make sure NDEBUG is defined
    $(SED) -i '/NDEBUG/ s|^#*||g' '$(1)'/Makefile

    #$(SED) -i 's| -fstack-protector | |g' '$(1)'/Makefile
    #$(SED) -i 's| -D_FORTIFY_SOURCE=2 | |g' '$(1)'/Makefile
    #$(SED) -i 's| -lssp | |g' '$(1)'/Makefile

    TARGET='$(TARGET)' $(MAKE) -C '$(1)' clean
    TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' io.h \
		libbiosig.a libbiosig2.a libgdf.a  libphysicalunits.a \
		libbiosig.def libbiosig2.def libgdf.def libphysicalunits.def \
		save2gdf

endef

define $(PKG)_BUILD_POST


    #TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' io.h libbiosig.a libbiosig2.a libgdf.a save2gdf libphysicalunits.a
    $(INSTALL)       '$(1)'/save2gdf            '$(PREFIX)/$(TARGET)/bin/save2gdf.exe'

    $(INSTALL) -m644 '$(1)/biosig.h'             '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/gdftime.h'             '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig-dev.h'         '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/libbiosig.a'          '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig.def' 	 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig.dll.a' 	 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig.dll' 	 '$(PREFIX)/$(TARGET)/lib/'

    $(INSTALL) -m644 '$(1)/libgdf.a'             '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libgdf.def' 		 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libgdf.dll.a' 	 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libgdf.dll'	 	 '$(PREFIX)/$(TARGET)/lib/'

    $(INSTALL) -m644 '$(1)/biosig2.h'            '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/libbiosig2.a'         '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig2.def' 	 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig2.dll.a' 	 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig2.dll'	 '$(PREFIX)/$(TARGET)/lib/'

    $(INSTALL) -m644 '$(1)/physicalunits.h'      '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.a'   '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.def' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.dll.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.dll' '$(PREFIX)/$(TARGET)/lib/'

    $(INSTALL) -m644 '$(1)/libbiosig.pc'         '$(PREFIX)/$(TARGET)/lib/pkgconfig/'

    ### make release file
    rm -f $(PREFIX)/$($(PKG)_SUBDIR).$(TARGET).zip
    cd $(PREFIX)/$(TARGET) && zip $(PREFIX)/$($(PKG)_SUBDIR).$(TARGET).zip \
		include/biosig.h include/biosig-dev.h include/biosig2.h include/io.h \
		lib/libbiosig.a lib/libbiosig.def lib/libbiosig.dll lib/libbiosig.dll.a \
		lib/libbiosig2.a lib/libbiosig2.def lib/libbiosig2.dll lib/libbiosig2.dll.a \
		lib/libgdf.a lib/libgdf.def lib/libgdf.dll lib/libgdf.dll.a \
		lib/libz.a lib/libcholmod.a lib/liblapack.a lib/libiconv.a lib/libiberty.a  \
		include/libiberty/*.h include/iconv.h \
		include/physicalunits.h \
		lib/libphysicalunits.a lib/libphysicalunits.def lib/libphysicalunits.dll lib/libphysicalunits.dll.a \
		bin/save2gdf.exe bin/sigviewer.exe

    mkdir -p $(PREFIX)/release/$(TARGET)/include/
    cd $(PREFIX)/$(TARGET) && cp -r \
		include/biosig.h include/biosig-dev.h include/biosig2.h include/io.h \
		include/libiberty include/iconv.h \
		include/physicalunits.h \
		$(PREFIX)/release/$(TARGET)/include/

    mkdir -p $(PREFIX)/release/$(TARGET)/lib/
    cd $(PREFIX)/$(TARGET) && cp -r \
		lib/libbiosig.a lib/libbiosig.def lib/libbiosig.dll lib/libbiosig.dll.a \
		lib/libbiosig2.a lib/libbiosig2.def lib/libbiosig2.dll lib/libbiosig2.dll.a \
		lib/libgdf.a lib/libgdf.def lib/libgdf.dll lib/libgdf.dll.a \
		lib/libz.a lib/libcholmod.a lib/liblapack.a lib/libiconv.a lib/libiberty.a  \
		lib/libphysicalunits.a lib/libphysicalunits.def lib/libphysicalunits.dll lib/libphysicalunits.dll.a \
		$(PREFIX)/release/$(TARGET)/lib/

    mkdir -p $(PREFIX)/release/$(TARGET)/bin/
    -cp $(PREFIX)/$(TARGET)/bin/save2gdf.exe $(PREFIX)/release/$(TARGET)/bin/

    mkdir -p $(PREFIX)/release/matlab/
    -cp $(1)/mex/mex* $(PREFIX)/release/matlab/

    cd '$(1)/win32' && zip $(PREFIX)/$($(PKG)_SUBDIR).$(TARGET).zip *.bat README

    #exit -1
    ### these cause problems when compiling stimfit
    rm -rf '$(PREFIX)/$(TARGET)/lib/libphysicalunits.dll.a' \
	'$(PREFIX)/$(TARGET)/lib/libbiosig.dll.a' \
	'$(PREFIX)/$(TARGET)/lib/libbiosig2.dll.a' \
	'$(PREFIX)/$(TARGET)/lib/libgdf.dll.a'

endef


define $(PKG)_BUILD_i686-pc-mingw32
	$($(PKG)_BUILD_PRE)
	#HOME=/home/as TARGET=$(TARGET) $(MAKE) -C '$(1)' mexw32
	$($(PKG)_BUILD_POST)
endef

define $(PKG)_BUILD_i686-w64-mingw32
	$($(PKG)_BUILD_PRE)
	$($(PKG)_BUILD_POST)
endef

define $(PKG)_BUILD_x86_64-w64-mingw32
	$($(PKG)_BUILD_PRE)
	#HOME=/home/as  TARGET=$(TARGET) $(MAKE) -C '$(1)' mexw64
	$($(PKG)_BUILD_POST)
endef

