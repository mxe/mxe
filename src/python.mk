# This file is part of MXE.
# See index.html for further information.

PKG             := python
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.0
$(PKG)_CHECKSUM := 3e1464bc2c1dfa74287bc58da81168f50b0ae5c7
$(PKG)_SUBDIR   := Python-$($(PKG)_VERSION)
$(PKG)_FILE     := Python-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://python.org/ftp/python/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv zlib

PATH_TO_HOST_PYTHON := $(PREFIX)/share/$($(PKG)_SUBDIR)

define $(PKG)_UPDATE
    wget -q -O- 'http://python.org/download/releases/' | \
    $(SED) -n 's_.*">Python \(3.3.[0-9]\)</a>.*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
	## Build HOSTPYTHON and Parser/pgen on HOST with unpatched sources
	## http://randomsplat.com/id5-cross-compiling-python-for-embedded-linux.html
	if ! $(PATH_TO_HOST_PYTHON)/python --version ; then \
		echo "Built host python and Parser/pgen in $(PATH_TO_HOST_PYTHON)";  \
		( cd $$(dirname $(PATH_TO_HOST_PYTHON)) && tar xf $(PWD)/pkg/$($(PKG)_FILE) ); \
		( cd $(PATH_TO_HOST_PYTHON) && \
			./configure && \
			$(MAKE) python Parser/pgen Modules/_freeze_importlib \
			) ; \
	fi

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
		CC_FOR_BUILD=$(TARGET)-gcc \
		PYTHON_FOR_BUILD=$(PREFIX)/$(TARGET)/python.exe \
		ac_cv_have_long_long_format=yes \
		./configure  \
		--without-threads \
		--with-libs='-lmsvcrt -liconv -lz' \
	       	--host='$(TARGET)' \
		--build="`config.guess`" \
	       	--prefix='$(PREFIX)/$(TARGET)/$($(PKG)_SUBDIR)' 

	## modify Makefile such that HOSTPGEN is used instead of Parser/pgen.exe
	$(SED) -i 's#$$(PGEN) $$(GRAMMAR_INPUT)#$$(HOSTPGEN) $$(GRAMMAR_INPUT)#g' '$(1)'/Makefile

	## modify Makefile such that HOST_FREEZE_IMPORTLIB is used instead of _freeze_importlib.exe
	$(SED) -i 's#./_freeze_importlib$$(EXE)#$$(HOST_FREEZE_IMPORTLIB)#g' '$(1)'/Makefile

	PYTHONHOME='$(1)':'$(1)'/Lib/ \
	$(MAKE) -C '$(1)' \
		HOSTPYTHON=$(PATH_TO_HOST_PYTHON)/python \
		HOSTPGEN=$(PATH_TO_HOST_PYTHON)/Parser/pgen \
		HOST_FREEZE_IMPORTLIB=$(PATH_TO_HOST_PYTHON)/Modules/_freeze_importlib \
		BLDSHARED="$(TARGET)-gcc -shared" \
		CROSS_COMPILE=$(TARGET)- \
		CROSS_COMPILE_TARGET=yes \
		HOSTARCH=$(TARGET) \
		BUILDARCH=x86_64-linux-gnu \
		python.exe

	## runtime test using wine 
	[[ -z `wine '$(1)'/python.exe --version` ]] || echo "no runtime test - because wine is not available"
		
	## Install target system
	rm -rf '$(PREFIX)/$(TARGET)/$($(PKG)_SUBDIR)'
	cp -r '$(1)'  '$(PREFIX)/$(TARGET)/'
	cp -r '$(1)/python.exe'  '$(PREFIX)/$(TARGET)/bin/'

	ln -sf '$(PREFIX)/$(TARGET)/$($(PKG)_SUBDIR)/Include' '$(PREFIX)/$(TARGET)/include/$($(PKG)_SUBDIR)'
	
endef

