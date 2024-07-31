# This file is part of MXE.
# See index.html for further information.

PKG             := stimfit
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.16.3windows-portable
$(PKG)_CHECKSUM := 44729af1bd4879d4437e390c6ffdcf489f2bf7cb34517f5cbacbd0fc8a64f48f
$(PKG)_SUBDIR   := stimfit-$($(PKG)_VERSION)
$(PKG)_FILE     := stimfit-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/neurodroid/stimfit/archive/refs/tags/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc biosig wxwidgets hdf5 fftw levmar lapack

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/neurodroid/stimfit/tags' | \
    $(SED) -n 's_.*<a href="/neurodroid/stimfit/tags/\(0.[0-9\.]*\.*).tar.gz" rel="nofollow">.*_\1_ip' \
    head -1
endef

define $(PKG)_BUILD

    # rm -rf '$(1)' && git clone ~/src/stimfit '$(1)'

    cd '$(1)' && ./autogen.sh && CPPFLAGS="-std=gnu++17" \
	./configure --disable-python --with-biosig --with-pslope \
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

