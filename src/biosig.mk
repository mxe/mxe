# This file is part of MXE.
# See index.html for further information.

PKG             := biosig
$(PKG)_WEBSITE  := http://biosig.sf.net/
$(PKG)_DESCR    := biosig
$(PKG)_VERSION  := 2.6.1
$(PKG)_CHECKSUM := 558ee17cd7b4aa1547e98e52bb85cccccb7f7a81600f9bef3a50cd5b34d0729e
$(PKG)_SUBDIR   := biosig-$($(PKG)_VERSION)
$(PKG)_FILE     := biosig-$($(PKG)_VERSION).src.tar.xz
$(PKG)_URL      := https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc             zlib libiconv libb64              tinyxml suitesparse dcmtk

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://biosig.sourceforge.io/download.html' | \
        $(SED) -n 's_.*>v\([0-9]\.[0-9]\.[0-9]\)<.*_\1_p' | \
        head -1
endef

### TODO:
#  lib*.dll -> bin/	# shared
#  lib*.dll.a -> lib/	# shared
#  lib*.a -> lib/	# static, both ?


define $(PKG)_BUILD_PRE
    #rm -rf '$(1)'
    #git clone ~/src/biosig-code '$(1)'
    # rsync -av ~/src/biosig-code/ '$(1)'/
    # rm -rf '$(1)'
    # git clone ~/src/biosig-code '$(1)'
    # cp -rp /fs3/home/schloegl/src/biosig-code '$(1)'

    cd '$(1)' && autoreconf -fi

    cd '$(1)' && ./configure \
        ac_cv_func_malloc_0_nonnull=yes \
        ac_cv_func_realloc_0_nonnull=yes \
        $(MXE_CONFIGURE_OPTS)

    # make sure NDEBUG is defined
    $(SED) -i '/NDEBUG/ s|#||g' '$(1)'/biosig4c++/Makefile

    TARGET='$(TARGET)' $(MAKE) -C '$(1)' clean
    TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' lib tools

    $(INSTALL) -m644 '$(1)/biosig4c++/biosig.h'			'$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig4c++/biosig2.h'		'$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig4c++/gdftime.h'		'$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig4c++/biosig-dev.h'		'$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig4c++/physicalunits.h'		'$(PREFIX)/$(TARGET)/include/'

    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.a'		'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libgdf.a'			'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.a'	'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.pc'		'$(PREFIX)/$(TARGET)/lib/pkgconfig/'

    $(INSTALL) -m644 '$(1)/biosig4c++/save2gdf.exe'		'$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m644 '$(1)/biosig4c++/biosig_fhir.exe'		'$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m644 '$(1)/biosig4c++/biosig2gdf.exe'		'$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m644 '$(1)/biosig4c++/physicalunits.exe'	'$(PREFIX)/$(TARGET)/bin/'

    ### prepare release file
    rm -rf $(PREFIX)/release/$(TARGET)/
    mkdir -p $(PREFIX)/release/$(TARGET)/{include,bin,lib,matlab,mathematica}/
    cd $(PREFIX)/$(TARGET) && cp -r \
		bin/save2gdf.exe bin/biosig_fhir.exe bin/biosig2gdf.exe bin/physicalunits.exe \
		$(PREFIX)/release/$(TARGET)/bin/
    cd $(PREFIX)/$(TARGET) && cp -r \
		include/biosig.h include/biosig-dev.h include/biosig2.h include/gdftime.h  \
		include/physicalunits.h \
		$(PREFIX)/release/$(TARGET)/include/

endef


define $(PKG)_BUILD_STATIC
    $($(PKG)_BUILD_PRE)

    ## TODO
    mkdir -p $(PREFIX)/release/$(TARGET)/matlab/
    -(cp $(1)/biosig4c++/mex/*mex* $(PREFIX)/release/$(TARGET)/matlab/)

    (cd $(1)/biosig4c++ && cp -r \
		libbiosig.a \
		libgdf.a \
		libphysicalunits.a \
		$(PREFIX)/release/$(TARGET)/lib/)

    # build matlab
    -$($(PKG)_BUILD_MAT_$(TARGET))

    $($(PKG)_BUILD_RELEASE)
endef


define $(PKG)_BUILD_SHARED
    $($(PKG)_BUILD_PRE)

    ### TODO: mexw64, mathematica

    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.def'		'$(PREFIX)/$(TARGET)/lib/'
    # $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.dll.a'		'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.dll'		'$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig-3.dll'		'$(PREFIX)/$(TARGET)/bin/'

    $(INSTALL) -m644 '$(1)/biosig4c++/libgdf.def'		'$(PREFIX)/$(TARGET)/lib/'
    # $(INSTALL) -m644 '$(1)/biosig4c++/libgdf.dll.a'		'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libgdf-3.dll'		'$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libgdf.dll'		'$(PREFIX)/$(TARGET)/bin/'

    $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.def'	'$(PREFIX)/$(TARGET)/lib/'
    # $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.dll.a'	'$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits-3.dll'	'$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.dll'	'$(PREFIX)/$(TARGET)/bin/'

    (cd $(1)/biosig4c++ && cp -r \
		libbiosig.dll \
		libgdf.dll \
		libphysicalunits.dll \
		$(PREFIX)/release/$(TARGET)/lib/)

    $($(PKG)_BUILD_RELEASE)
endef


define $(PKG)_BUILD_MAT_x86_64-w64-mingw32.static
	TARGET=$(TARGET) $(MAKE) -C '$(1)'/biosig4c++ mexw64
	-(MLINKDIR=/usr/local/Wolfram/Mathematica/14.0.0/ TARGET=$(TARGET) $(MAKE) -C '$(1)'/biosig4c++ win32mma)
endef
define $(PKG)_BUILD_MAT_i686-w64-mingw32.static
	TARGET=$(TARGET) $(MAKE) -C '$(1)'/biosig4c++ mexw32
	-(MLINKDIR=/usr/local/Wolfram/Mathematica/14.0.0/ TARGET=$(TARGET) $(MAKE) -C '$(1)'/biosig4c++ win32mma)
endef
define $(PKG)_BUILD_MAT_x86_64-w64-mingw32.shared
	TARGET=$(TARGET) $(MAKE) -C '$(1)'/biosig4c++ mexw64
endef
define $(PKG)_BUILD_MAT_i686-w64-mingw32.shared
	TARGET=$(TARGET) $(MAKE) -C '$(1)'/biosig4c++ mexw32
endef


define $(PKG)_BUILD_RELEASE
    ### make release file
    rm -f $(PREFIX)/release/$($(PKG)_SUBDIR).$(TARGET).zip

    ### FIXME
    -cp $(1)/biosig4c++/mex/*mex* $(PREFIX)/release/$(TARGET)/matlab/
    -cp $(1)/biosig4c++/mma/biosig.exe $(PREFIX)/release/$(TARGET)/mathematica/

    cd '$(1)/biosig4c++/win32' && cp *.bat  $(PREFIX)/release/$(TARGET)/bin/
    cd '$(1)/biosig4c++/win32' && cp README $(PREFIX)/release/$(TARGET)/

    cd $(PREFIX)/release/ && zip -r $(PREFIX)/release/$($(PKG)_SUBDIR).$(TARGET).zip $(TARGET)

endef

