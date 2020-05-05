# This file is part of MXE.
# See index.html for further information.

PKG             := stimfit
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.15.8
$(PKG)_CHECKSUM := 8a5330612245d3f442ed640b0df91028aa4798301bb6844eaf1cf9b463dfc466
$(PKG)_SUBDIR   := stimfit-$($(PKG)_VERSION)windows
$(PKG)_FILE     := stimfit-$($(PKG)_VERSION)windows.tar.gz
$(PKG)_URL      := https://github.com/neurodroid/$(PKG)/archive/v$($(PKG)_VERSION)windows.tar.gz
$(PKG)_DEPS     := cc biosig wxwidgets hdf5 tinyxml fftw levmar openblas

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/neurodroid/stimfit/releases' | \
    $(SED) -n 's_.*<a href="/neurodroid/stimfit/archive/\([0-9\.]*\)windows.tar.gz" rel="nofollow">.*_\1_ip' \
    head -1
endef

define $(PKG)_BUILD

    #rm -rf '$(1)'
    #rsync -avL  ~/src/stimfit/* '$(1)/'
    #git clone ~/src/stimfit '$(1)'

    cd '$(1)' && ./autogen.sh && CPPFLAGS="-std=gnu++17" \
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

