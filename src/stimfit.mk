# This file is part of MXE.
# See index.html for further information.

PKG             := stimfit
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.15.4
$(PKG)_CHECKSUM := 2e99df9c8b92c90b11a2c87a24244863be4a0f3a42f1ae9cbfbb72678b6dbb44
$(PKG)_SUBDIR   := stimfit-0.15.4windows
$(PKG)_FILE     := 0.15.4windows.tar.gz
$(PKG)_URL      := https://github.com/neurodroid/$(PKG)/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libbiosig wxwidgets hdf5 boost fftw libtool

define $(PKG)_UPDATE
    wget -q -O- 'https://github.com/neurodroid/stimfit/releases' | \
	sed -n 's_.*<a href="/neurodroid/stimfit/archive/\([0-9\.]*\)windows.tar.gz" rel="nofollow">.*_\1_ip' \
	head -1
endef

define $(PKG)_BUILD

	cd '$(1)' && CPPFLAGS="-std=gnu++11" \
	./configure --disable-python --with-biosig2 --with-pslope \
		--with-hdf5-prefix=$(PREFIX)/$(TARGET) \
		--with-wx-config=$(PREFIX)/$(TARGET)/bin/wx-config \
		--with-sysroot=$(PREFIX)/$(TARGET)/bin \
		--host='$(TARGET)' \
		--build="`config.guess`" \
		--prefix='$(PREFIX)/$(TARGET)' \
		--enable-static \
		--disable-shared

    CXX='$(PREFIX)/bin/$(TARGET)-g++' \
	CC='$(PREFIX)/bin/$(TARGET)-gcc' \
	PKGCONF='$(PREFIX)/bin/$(TARGET)-pkg-config' \
	WXCONF='$(PREFIX)/$(TARGET)/bin/wx-config' \
	CROSS='$(PREFIX)/$(TARGET)/bin/' \
	make -C '$(1)' -f Makefile.static -j '$(JOBS)'

    $(INSTALL) '$(1)/stimfit.exe' '$(PREFIX)/$(TARGET)/bin/'

endef

