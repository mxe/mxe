# This file is part of MXE.
# See index.html for further information.

PKG             := python
$(PKG)_IGNORE   := 
$(PKG)_CHECKSUM := 3e1464bc2c1dfa74287bc58da81168f50b0ae5c7
$(PKG)_SUBDIR   := Python-$($(PKG)_VERSION)
$(PKG)_FILE     := Python-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://python.org/ftp/python/3.3.0/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
#    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
#    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
	## THIS IS WORK IN PROGRESS AND CURRENTLY NOT WORKING
	[[ -z `wine help >/dev/null` ]] || echo 'wine is required';

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
		PYTHON_FOR_BUILD=python2.6 \
		ac_cv_have_long_long_format=yes \
		./configure  \
		--without-threads \
		--with-libs='-lmsvcrt -liconv' \
	       	--host='$(TARGET)' \
		--build="`config.guess`" \
	       	--prefix='$(PREFIX)/$(TARGET)' 

	#$(SED) -i 's#Parser\/pgen$$(EXE)#Parser\/pgen#g' '$(1)'/Makefile 
	#$(SED) -i 's#^\t\t$$(CC) $$(OPT) $$(PY_LDFLAGS) $$(PGENOBJS) $$(LIBS)#\t\tgcc $$(OPT) $$(PY_LDFLAGS) $$(PGENOBJS) $$(LIBS)#g' '$(1)'/Makefile

	$(SED) -i 's#^\t\t$$(PGEN) $$(GRAMMAR_INPUT) $$(GRAMMAR_H) $$(GRAMMAR_C)#\t\twine $$(PGEN) $$(GRAMMAR_INPUT) $$(GRAMMAR_H) $$(GRAMMAR_C)#g' '$(1)'/Makefile

	$(MAKE) -C '$(1)' 
	
endef
