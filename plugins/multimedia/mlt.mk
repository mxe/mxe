# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mlt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.10.0
$(PKG)_CHECKSUM := 10642a80f81e12c6cc5405e60ced640b3dd325c793fe73207ae07de321ad6810
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libxml2 ffmpeg qtbase qtsvg dlfcn-win32 \
	frei0r-plugins ladspa-sdk fftw libsamplerate vorbis \
	sdl2 gtk2
	#sox movit exif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/mltframework/mlt/tags' | \
    grep '<a href="/mltframework/mlt/archive/' | \
    $(SED) -n 's,.*href="/mltframework/mlt/archive/v\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
	$(MAKE) -C '$(1)' distclean
    cd '$(1)' && \
	CFLAGS="-I$(PREFIX)/$(TARGET)/include" \
	PKG_CONFIG_LIBDIR=$(PREFIX)/$(TARGET)/lib/pkgconfig \
	CC=$(TARGET)-gcc \
	./configure $(MXE_CONFIGURE_OPTS) \
		--target-os=MinGW --rename-melt=melt.exe \
		--qt-includedir=$(PREFIX)/$(TARGET)/qt5/include \
		--qt-libdir=$(PREFIX)/$(TARGET)/qt5/lib \
		--enable-gpl --enable-gpl3 --disable-rtaudio --disable-sox --disable-sdl --enable-sdl2
	$(MAKE) -C '$(1)' uninstall
	$(MAKE) -C '$(1)/src/modules/lumas' CC=$(BUILD_CC) luma
	CXXFLAGS=-std=c++11 \
	CFLAGS="-I$(PREFIX)/$(TARGET)/include" \
	LDFLAGS="-L$(PREFIX)/$(TARGET)/lib" \
	PKG_CONFIG_LIBDIR=$(PREFIX)/$(TARGET)/lib/pkgconfig \
	$(MAKE) -C '$(1)' \
		CC=$(TARGET)-gcc \
		CXX=$(TARGET)-g++ \
		LD=$(TARGET)-ld \
		-j '$(JOBS)' all
    $(MAKE) -C '$(1)' -j 1 install
	$(SED) -i 's/swresample,//' $(PREFIX)/$(TARGET)/share/mlt/core/loader.ini
endef

