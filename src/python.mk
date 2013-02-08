# This file is part of MXE.
# See index.html for further information.

PKG             := python
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3e1464bc2c1dfa74287bc58da81168f50b0ae5c7
$(PKG)_SUBDIR   := Python-$($(PKG)_VERSION)
$(PKG)_FILE     := Python-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://python.org/ftp/python/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv


PATH_TO_HOST_PYTHON := $(PWD)/$($(PKG)_SUBDIR)/

define $(PKG)_UPDATE
    wget -q -O- 'http://python.org/download/releases/' | \
    $(SED) -n 's_.*">Python \(3.3.[0-9]\)</a>.*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

	## Build HOSTPYTHON and Parser/pgen on HOST with unpatched sources
	## http://randomsplat.com/id5-cross-compiling-python-for-embedded-linux.html
	if ! ($(PATH_TO_HOST_PYTHON)hostpython --version) ; then \
		echo "Built host python and Parser/pgen in $(PATH_TO_HOST_PYTHON)";  \
		(cd $$(dirname $(PATH_TO_HOST_PYTHON)) && tar xf $(PWD)/pkg/$($(PKG)_FILE) ); \
		( cd $(PATH_TO_HOST_PYTHON)   && \
			./configure && \
			make python Parser/pgen && \
			mv python hostpython && \
			mv Parser/pgen Parser/hostpgen && \
			make distclean) ;  \
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
		PYTHON_FOR_BUILD='wine python.exe ' \
		ac_cv_have_long_long_format=yes \
		./configure  \
		--without-threads \
		--with-libs='-lmsvcrt -liconv' \
	       	--host='$(TARGET)' \
		--build="`config.guess`" \
	       	--prefix='$(PREFIX)/$(TARGET)' 

	## modify Makefile such that HOSTPGEN is used instead of Parser/pgen.exe
	$(SED) -i 's#$$(PGEN) $$(GRAMMAR_INPUT)#$$(HOSTPGEN) $$(GRAMMAR_INPUT)#g' '$(1)'/Makefile

	## modify Makefile such that wine is used when calling _freeze_importlib.exe
	$(SED) -i 's#./_freeze_importlib$$(EXE)#wine ./_freeze_importlib$$(EXE)#g' '$(1)'/Makefile

	PYTHONHOME='$(1)':'$(1)'/Lib/ \
	$(MAKE) -C '$(1)' \
		HOSTPYTHON=$(PATH_TO_HOST_PYTHON)hostpython \
		HOSTPGEN=$(PATH_TO_HOST_PYTHON)Parser/hostpgen \
		BLDSHARED="$(TARGET)-gcc -shared" \
		CROSS_COMPILE=$(TARGET)- \
		CROSS_COMPILE_TARGET=yes \
		HOSTARCH=$(TARGET) \
		BUILDARCH=x86_64-linux-gnu \
		python.exe

	## runtime test
        wine python.exe --version

	## Install files
	cp '$(1)'/python.exe  	'$(PREFIX)/$(TARGET)/bin/'
	cp '$(1)'/libpython*    '$(PREFIX)/$(TARGET)/lib/'
	mkdir -p                '$(PREFIX)/$(TARGET)/python'
	mv '$(1)/Include'       '$(PREFIX)/$(TARGET)/python/include'
	mv '$(1)/Lib'           '$(PREFIX)/$(TARGET)/python/include'
	
endef

