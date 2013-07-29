# This file is part of MXE.
# See index.html for further information.

PKG             := neuron
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 7.3
$(PKG)_CHECKSUM := d79124f228135775769e661e1d57303476740ef6
$(PKG)_SUBDIR   := nrn-7.3
$(PKG)_FILE     := nrn-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.neuron.yale.edu/ftp/neuron/versions/v7.3/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc readline nrniv pthreads termcap


PATH_TO_HOST_NEURON := $(PREFIX)/share/$($(PKG)_SUBDIR)

define $(PKG)_UPDATE
    wget -q -O- 'http://www.neuron.yale.edu/neuron/download/getstd' | \
    $(SED) -n 's_.*>[0-9]\./nrn-\([0-9]\.[0-9]\.[0-9]\).*tar.gz">_\1_ip' | \
    head -1
endef


define $(PKG)_BUILD

	### This is neeeded because nmodl/nocmodl needs to run on host
	if [[ ! -d $(PATH_TO_HOST_NEURON) ]] ; then \
		echo "Built host neuron and nocmodl in $(PATH_TO_HOST_NEURON)";  \
		( cd $$(dirname $(PATH_TO_HOST_NEURON)) && tar xf $(PWD)/pkg/$($(PKG)_FILE) ); \
		( cd $(PATH_TO_HOST_NEURON) && \
			./configure --with-nmodl-only --without-x && \
			$(MAKE)                         ) ; \
	fi

        cd '$(1)' && ./configure \
		--without-memacs \
		--disable-cygwin \
		--prefix='$(PREFIX)/$(TARGET)' \
		--build="`config.guess`" \
		--host='$(TARGET)' \
		--with-iv='$(PREFIX)/$(TARGET)' \
		--disable-shared \
		--enable-static

	### nocmodl of host (not the target one) ###
	$(SED) -i 's#^NMODL = ../nmodl/nocmodl#NMODL = $(PATH_TO_HOST_NEURON)/src/nmodl/nocmodl#' '$(1)'/src/nrnoc/Makefile 
	#$(SED) -i '/^am_ivoc_OBJECTS/ s#\\$$# ivocwin.$$\(OBJEXT\) \\#' '$(1)'/src/ivoc/Makefile
	$(SED) -i  's#^\tg++ #\t$$\(CXX\) #g' '$(1)'/src/nrniv/Makefile

	$(MAKE) -C '$(1)' 
	$(MAKE) -C '$(1)' install 

endef

