# This file is part of MXE.
# See index.html for further information.

PKG             := biosig
$(PKG)_WEBSITE  := http://biosig.sf.net/
$(PKG)_DESCR    := biosig
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.5
$(PKG)_CHECKSUM := 20e72a5a07d1bf8baa649efe437b4d3ed99944f0e4dfc1fbe23bfbe4d9749ed5
$(PKG)_SUBDIR   := biosig4c++-$($(PKG)_VERSION)
$(PKG)_FILE     := biosig4c++-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/biosig/files/BioSig%20for%20C_C%2B%2B/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc suitesparse zlib libiberty libiconv libb64 lapack dcmtk tinyxml

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://biosig.sourceforge.io/download.html' | \
        $(GREP) biosig4c | \
        $(SED) -n 's_.*>v\([0-9]\.[0-9]\.[0-9]\)<.*_\1_p' | \
        $(SORT) -V | \
        tail -1
endef

define $(PKG)_BUILD_PRE

    cd '$(SOURCE_DIR)' && autoreconf -fi 
    cd '$(SOURCE_DIR)' && '$(SOURCE_DIR)'/configure $(MXE_CONFIGURE_OPTS)

    # make sure NDEBUG is defined
    $(SED) -i '/NDEBUG/ s|#||g' '$(1)'/Makefile

    ### disables declaration of sopen from io.h (imported through unistd.h)
    $(SED) -i '/ sopen/ s#^/*#//#g' $(PREFIX)/$(TARGET)/include/io.h

    #$(SED) -i 's| -fstack-protector | |g' '$(1)'/Makefile
    #$(SED) -i 's| -D_FORTIFY_SOURCE=2 | |g' '$(1)'/Makefile
    #$(SED) -i 's| -lssp | |g' '$(1)'/Makefile

    TARGET='$(TARGET)' $(MAKE) -C '$(1)' clean
    TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' \
		libbiosig.a libgdf.a  libphysicalunits.a \
		libbiosig.def libgdf.def libphysicalunits.def \
		tools

endef

define $(PKG)_BUILD_POST

    TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' tools
    $(INSTALL) -m644 '$(1)/save2gdf.exe'         '$(PREFIX)/$(TARGET)/bin/test-biosig.exe'
    $(INSTALL) -m644 '$(1)'/*.exe         '$(PREFIX)/$(TARGET)/bin/'

    $(INSTALL) -m644 '$(1)/biosig.h'             '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig2.h'            '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/gdftime.h'            '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig-dev.h'         '$(PREFIX)/$(TARGET)/include/'

    $(INSTALL) -m644 '$(1)/libbiosig.a'          '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig.def' 	 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig.dll.a' 	 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig.dll' 	 '$(PREFIX)/$(TARGET)/bin/'

    $(INSTALL) -m644 '$(1)/libgdf.a'             '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libgdf.def' 		 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libgdf.dll.a' 	 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libgdf.dll'	 	 '$(PREFIX)/$(TARGET)/bin/'


    $(INSTALL) -m644 '$(1)/physicalunits.h'      '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.a'   '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.def' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.dll.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.dll' '$(PREFIX)/$(TARGET)/bin/'

    $(INSTALL) -m644 '$(1)/libbiosig.pc'         '$(PREFIX)/$(TARGET)/lib/pkgconfig/'

endef


define $(PKG)_BUILD_i686-pc-mingw32
	$($(PKG)_BUILD_PRE)
	#HOME=/home/as TARGET=$(TARGET) $(MAKE) -C '$(1)' mexw32
	$($(PKG)_BUILD_POST)
endef

define $(PKG)_BUILD_i686-w64-mingw32
	$($(PKG)_BUILD_PRE)
	#TARGET=$(TARGET) $(MAKE) -C '$(1)' mexw32
	$($(PKG)_BUILD_POST)
endef

define $(PKG)_BUILD_x86_64-w64-mingw32
	$($(PKG)_BUILD_PRE)
	#TARGET=$(TARGET) $(MAKE) -C '$(1)' mexw64
	$($(PKG)_BUILD_POST)
endef

