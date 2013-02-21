# This file is part of MXE.
# See index.html for further information.

PKG             := neuron
$(PKG)_IGNORE   := 
$(PKG)_CHECKSUM := 29e4ba0d6c3e11f99350f4c7eb97847772c492c4
$(PKG)_SUBDIR   := nrn-$($(PKG)_VERSION)
$(PKG)_FILE     := nrn-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.neuron.yale.edu/ftp/neuron/versions/v$($(PKG)_VERSION)/nrn-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc libdnet libz termcap readline nrniv

define $(PKG)_UPDATE
    wget -q -O- 'http://www.neuron.yale.edu/neuron/download/getstd' | \
    $(SED) -n 's_.*>[0-9]\./nrn-\([0-9]\.[0-9]\.[0-9]\).*tar.gz">_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

    #	--with-iv='$(PREFIX)/$(TARGET)' \

    #cd '$(1)' && autoconf

    CC=$(TARGET)-gcc CXX=$(TARGET)-g++ LD=$(TARGET)-ld PKG_CONFIG=$(TARGET)-pkg_config \
    cd '$(1)' &&  ./configure \
	--without-iv \
	--without-memacs \
        --prefix='$(PREFIX)/$(TARGET)' \
        --build="`config.guess`" \
        --host='$(TARGET)' \
        --disable-shared \
        --enable-static 

	#--with-gnu-ld   

	#--enable-termcap \
	#--disable-cygwin \
 	#--with-readline='$(PREFIX)/$(TARGET)' 

    $(MAKE) -C '$(1)' 
    $(MAKE) -C '$(1)' install 

endef

