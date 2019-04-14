# This file is part of MXE.
# See index.html for further information.

PKG             := libbiosig
$(PKG)_WEBSITE  := http://biosig.sf.net/
$(PKG)_DESCR    := libbiosig
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.4
$(PKG)_CHECKSUM := 15c31173bf9b2fdf3a3764e2e422a30f9645cbbad12ba7e507d993ae562a3628
$(PKG)_SUBDIR   := biosig4c++-$($(PKG)_VERSION)
$(PKG)_FILE     := biosig4c++-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/biosig/files/BioSig%20for%20C_C%2B%2B/src/$($(PKG)_FILE)/download
$(PKG)_DEPS     := cc suitesparse zlib libiberty libiconv libb64 lapack dcmtk

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://biosig.sourceforge.net/download.html' | \
        $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip' | \
        head -1
endef

define $(PKG)_BUILD_PRE

    cd '$(1)' && ./configure \
        ac_cv_func_malloc_0_nonnull=yes \
        ac_cv_func_realloc_0_nonnull=yes \
        $(MXE_CONFIGURE_OPTS)

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
		libbiosig.def libgdf.def libphysicalunits.def

endef

define $(PKG)_BUILD_POST

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
		lib/libbiosig.a lib/libbiosig.def bin/libbiosig.dll lib/libbiosig.dll.a \
		lib/libgdf.a lib/libgdf.def bin/libgdf.dll lib/libgdf.dll.a \
		lib/libz.a lib/libcholmod.a lib/liblapack.a lib/libiconv.a lib/libiberty.a  \
		lib/libphysicalunits.a lib/libphysicalunits.def bin/libphysicalunits.dll lib/libphysicalunits.dll.a \
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
	'$(PREFIX)/$(TARGET)/lib/libgdf.dll.a'

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

