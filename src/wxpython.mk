# This file is part of MXE.
# See index.html for further information.

PKG             := wxpython
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9.4.0
$(PKG)_CHECKSUM := c292cd45b51e29c558c4d9cacf93c4616ed738b9
$(PKG)_SUBDIR   := wxPython-src-$($(PKG)_VERSION)
$(PKG)_FILE     := wxPython-src-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://sourceforge.net/projects/wxpython/files/wxPython/$($(PKG)_VERSION)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc 

define $(PKG)_UPDATE
    wget -q -O- 'http://wxpython.org/download.php' | \
    $(SED) -n 's_.*/wxPython-src-\([0-9\.]*\)\.tar\.bz2">wxPython-src</a>.*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

	## CONFIGURATION
	CC=$(TARGET)-gcc CXX=$(TARGET)-g++ PKG_CONFIG=$(TARGET)-pkg_config \
	cd '$(1)' && ./autogen.sh

	CC=$(TARGET)-gcc CXX=$(TARGET)-g++ PKG_CONFIG=$(TARGET)-pkg_config \
	cd '$(1)' && ./configure \
	        --build="`config.guess`" \
	        --host='$(TARGET)' \
	        $(LINK_STYLE) \
	        --prefix='$(PREFIX)/$(TARGET)' \
		--enable-metafiles \
		--enable-monolithic \
		--with-zlib 

	## COMPILATION
	$(MAKE) -C '$(1)' -j '$(JOBS)'

	## INSTALLATION 	
	#$(MAKE) -C '$(1)' -j 1 install
 	### there is some naming conflict with wxwidgets, both provide libwx* files with same name 
	echo "installing of wxPython is rather crude - some files should be probably placed somewhere else"
	cp -r '$(1)'/wxPython $(PREFIX)/$(TARGET)/

endef

$(PKG)_BUILD_i686-pc-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =
