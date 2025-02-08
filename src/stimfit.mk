# This file is part of MXE.
# See index.html for further information.

PKG             := stimfit
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.16.5
# $(PKG)_CHECKSUM := 9d7e8b9ca3ab10990230b17d8a47ac2bd25d32c7d501fac1e1768980c548195e
$(PKG)_SUBDIR   := stimfit-$($(PKG)_VERSION)debian
$(PKG)_FILE     := stimfit-$($(PKG)_VERSION)debian.tar.gz
# $(PKG)_URL      := https://github.com/neurodroid/stimfit/archive/refs/tags/v0.16.5debian.tar.gz
# https://github.com/neurodroid/stimfit/archive/refs/tags/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc biosig wxwidgets hdf5 fftw levmar openblas

#define $(PKG)_UPDATE
#    $(WGET) -q -O- 'https://github.com/neurodroid/stimfit/tags' | \
#    $(SED) -n 's_.*<a href="/neurodroid/stimfit/tags/\(0.[0-9\.]*\.*).tar.gz" rel="nofollow">.*_\1_ip' \
#    head -1
#endef

define $(PKG)_BUILD

    # rm -rf '$(1)' && git clone ~/src/stimfit '$(1)'

    cd '$(1)' && ./autogen.sh &&  \
	./configure CXXFLAGS="-std=gnu++17 -DwxDEBUG_LEVEL=0 -DNDEBUG " \
		--disable-python --with-biosig --with-pslope \
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
	$(MAKE) -C '$(1)' -f Makefile.static -j '$(JOBS)'

    $(INSTALL) '$(1)/stimfit.exe' '$(PREFIX)/$(TARGET)/bin/'

endef

