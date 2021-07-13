# This file is part of MXE.
# See index.html for further information.

PKG             := biosig
$(PKG)_WEBSITE  := http://biosig.sf.net/
$(PKG)_DESCR    := biosig
$(PKG)_VERSION  := 2.3.0
$(PKG)_CHECKSUM := 9c66d1167628d6c2027168fb82bcd3c28357e59bd5d8b1d9e615457a2eb59ca0
$(PKG)_SUBDIR   := biosig-$($(PKG)_VERSION)
$(PKG)_FILE     := biosig-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/biosig/files/BioSig%20for%20C_C%2B%2B/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc suitesparse zlib libiberty libiconv libb64 lapack dcmtk tinyxml

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://biosig.sourceforge.io/download.html' | \
        $(SED) -n 's_.*>v\([0-9]\.[0-9]\.[0-9]\)<.*_\1_p' | \
        head -1
endef

define $(PKG)_BUILD_PRE

    cd '$(1)' && autoreconf -fi

    cd '$(1)' && ./configure \
        ac_cv_func_malloc_0_nonnull=yes \
        ac_cv_func_realloc_0_nonnull=yes \
        $(MXE_CONFIGURE_OPTS)

    # make sure NDEBUG is defined
    $(SED) -i '/NDEBUG/ s|#||g' '$(1)'/biosig4c++/Makefile

    TARGET='$(TARGET)' $(MAKE) -C '$(1)' clean
    TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' lib tools

endef

define $(PKG)_BUILD_POST

    $(INSTALL) -m644 '$(1)/biosig4c++/biosig.h'			'$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig4c++/biosig2.h'		'$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig4c++/gdftime.h'		'$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig4c++/biosig-dev.h'		'$(PREFIX)/$(TARGET)/include/'

    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.a'		'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.def'		'$(PREFIX)/$(TARGET)/lib/'
    # $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.dll.a'	'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.dll'		'$(PREFIX)/$(TARGET)/bin/'

    $(INSTALL) -m644 '$(1)/biosig4c++/libgdf.a'			'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libgdf.def'		'$(PREFIX)/$(TARGET)/lib/'
    # $(INSTALL) -m644 '$(1)/biosig4c++/libgdf.dll.a'		'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libgdf.dll'		'$(PREFIX)/$(TARGET)/bin/'

    $(INSTALL) -m644 '$(1)/biosig4c++/physicalunits.h'		'$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.a'	'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.def'	'$(PREFIX)/$(TARGET)/lib/'
    # $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.dll.a'	'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.dll'	'$(PREFIX)/$(TARGET)/bin/'

    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.pc'		'$(PREFIX)/$(TARGET)/lib/pkgconfig/'

    $(INSTALL) -m644 '$(1)/biosig4c++/save2gdf.exe'		'$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m644 '$(1)/biosig4c++/biosig_fhir.exe'		'$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m644 '$(1)/biosig4c++/biosig2gdf.exe'		'$(PREFIX)/$(TARGET)/bin/'

    ### make release file
    rm -f $(PREFIX)/$($(PKG)_SUBDIR).$(TARGET).zip
    cd $(PREFIX)/$(TARGET) && zip $(PREFIX)/$($(PKG)_SUBDIR).$(TARGET).zip \
		include/biosig.h include/biosig-dev.h include/biosig2.h include/gdftime.h  \
		lib/libbiosig.a lib/libbiosig.def bin/libbiosig.dll lib/libbiosig.dll.a \
		lib/libgdf.a lib/libgdf.def bin/libgdf.dll lib/libgdf.dll.a \
		lib/libz.a lib/libcholmod.a lib/liblapack.a lib/libiconv.a lib/libiberty.a  \
		include/libiberty/*.h include/iconv.h \
		include/physicalunits.h \
		lib/libphysicalunits.a lib/libphysicalunits.def bin/libphysicalunits.dll lib/libphysicalunits.dll.a

    mkdir -p $(PREFIX)/release/$(TARGET)/include/
    cd $(PREFIX)/$(TARGET) && cp -r \
		include/biosig.h include/biosig-dev.h include/biosig2.h include/gdftime.h \
		include/libiberty include/iconv.h \
		include/physicalunits.h \
		$(PREFIX)/release/$(TARGET)/include/

    mkdir -p $(PREFIX)/release/$(TARGET)/lib/
    cd $(PREFIX)/$(TARGET) && cp -r \
		lib/libbiosig.a lib/libbiosig.def bin/libbiosig.dll \
		lib/libgdf.a lib/libgdf.def bin/libgdf.dll \
		lib/libz.a lib/libcholmod.a lib/liblapack.a lib/libiconv.a lib/libiberty.a  \
		lib/libphysicalunits.a lib/libphysicalunits.def bin/libphysicalunits.dll \
		$(PREFIX)/release/$(TARGET)/lib/
    -cd $(PREFIX)/$(TARGET) && cp -r \
		lib/libbiosig.dll.a \
		lib/libgdf.dll.a \
		lib/libphysicalunits.dll.a \
		$(PREFIX)/release/$(TARGET)/lib/

    mkdir -p $(PREFIX)/release/$(TARGET)/bin/
    -cp $(PREFIX)/$(TARGET)/bin/save2gdf.exe $(PREFIX)/release/$(TARGET)/bin/

    mkdir -p $(PREFIX)/release/matlab/
    -cp $(1)/biosig4c++/mex/mex* $(PREFIX)/release/matlab/

    cd '$(1)/biosig4c++/win32' && zip $(PREFIX)/$($(PKG)_SUBDIR).$(TARGET).zip *.bat README

    #exit -1
    ### these cause problems when compiling stimfit
    #rm -rf '$(PREFIX)/$(TARGET)/lib/libphysicalunits.dll.a' \
    #	'$(PREFIX)/$(TARGET)/lib/libbiosig.dll.a' \
    #	'$(PREFIX)/$(TARGET)/lib/libgdf.dll.a'

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

