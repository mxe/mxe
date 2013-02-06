# This file is part of MXE.
# See index.html for further information.

PKG             := python
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3e1464bc2c1dfa74287bc58da81168f50b0ae5c7
$(PKG)_SUBDIR   := Python-$($(PKG)_VERSION)
$(PKG)_FILE     := Python-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://python.org/ftp/python/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://python.org/download/releases/' | \
    $(SED) -n 's_.*">Python \(3.3.[0-9]\)</a>.*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
	## THIS IS WORK IN PROGRESS

	## Cross compiling python, see also
	## http://bugs.python.org/issue1597850
	## http://cawanblog.blogspot.co.at/

	echo ac_cv_file__dev_ptmx=no > '$(1)'/config.site 
	echo ac_cv_file__dev_ptc=no >> '$(1)'/config.site 

	## use patch set git://github.com/niXman/mingw-builds.git

	cd '$(1)' && autoconf

	cd '$(1)' && \
		MACHDEP=Linux \
		cross_compiling=yes \
		CONFIG_SITE=config.site \
		CC_FOR_BUILD=gcc \
		PYTHON_FOR_BUILD=python3.3 \
		ac_cv_have_long_long_format=yes \
		./configure  \
		--without-threads \
		--with-libs='-lmsvcrt -liconv' \
	       	--host='$(TARGET)' \
		--build="`config.guess`" \
	       	--prefix='$(PREFIX)/$(TARGET)' 

	## modify Makefile such that HOSTPGEN is used instead of Parser/pgen.exe
	$(SED) -i 's#$$(PGEN) $$(GRAMMAR_INPUT)#$$(HOSTPGEN) $$(GRAMMAR_INPUT)#g' '$(1)'/Makefile

	$(MAKE) -C '$(1)' \
		HOSTPYTHON=$(HOME)/src/Python-$($(PKG)_VERSION)/hostpython \
		HOSTPGEN=$(HOME)/src/Python-$($(PKG)_VERSION)/Parser/hostpgen \
		BLDSHARED="$(TARGET)-gcc -shared" \
		CROSS_COMPILE=$(TARGET)- \
		CROSS_COMPILE_TARGET=yes \
		HOSTARCH=$(TARGET) \
		BUILDARCH=x86_64-linux-gnu

	cd '$(1)' && make install \
		HOSTPYTHON=$(HOME)/src/Python-$($(PKG)_VERSION)/hostpython \
		BLDSHARED="$(TARGET)-gcc -shared"  \
		CROSS_COMPILE=$(TARGET)- \
		CROSS_COMPILE_TARGET=yes \
		--prefix='$(PREFIX)/$(TARGET)'
	
endef

