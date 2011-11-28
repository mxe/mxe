# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# gSOAP
PKG             := gsoap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.5
$(PKG)_CHECKSUM := 500b87b26d67e11c8b372f23d07e02ab0ecc4610
$(PKG)_SUBDIR   := gsoap-$(call SHORT_PKG_VERSION,$(PKG))
$(PKG)_FILE     := gsoap_$($(PKG)_VERSION).zip
$(PKG)_WEBSITE  := http://gsoap2.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/gsoap2/gSOAP/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls libgcrypt libntlm

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/gsoap2/files/gSOAP/' | \
    $(SED) -n 's,.*gsoap_\([0-9][^>]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Native build to get tools wsdl2h and soapcpp2
    cd '$(1)' && ./configure

    # Parallel bulds can fail
    $(MAKE) -C '$(1)'/gsoap -j 1

    # Install the native tools manually
    $(INSTALL) -m755 '$(1)'/gsoap/wsdl/wsdl2h  '$(PREFIX)/bin/$(TARGET)-wsdl2h'
    $(INSTALL) -m755 '$(1)'/gsoap/src/soapcpp2 '$(PREFIX)/bin/$(TARGET)-soapcpp2'

    $(MAKE) -C '$(1)' -j '$(JOBS)' clean

    # fix hard-coded gnutls dependencies
    $(SED) -i "s/-lgnutls/`'$(TARGET)-pkg-config' --libs-only-l gnutls`/g;" '$(1)/configure'

    # Build for mingw. Static by default.
    # Prevent undefined reference to _rpl_malloc.
    # http://groups.google.com/group/ikarus-users/browse_thread/thread/fd1d101eac32633f
    cd '$(1)' && ac_cv_func_malloc_0_nonnull=yes ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-gnutls \
        CPPFLAGS='-DWITH_NTLM'

    # Building for mingw requires native soapcpp2
    ln -sf '$(PREFIX)/bin/$(TARGET)-soapcpp2' '$(1)/gsoap/src/soapcpp2'

    # Parallel bulds can fail
    $(MAKE) -C '$(1)' -j 1 AR='$(TARGET)-ar'

    $(MAKE) -C '$(1)' -j 1 install
    # Apparently there is a tradition of compiling gsoap source files into applications.
    # Since we linked dom.cpp and dom.c into the libraries, this should not be necessary.
    # But we bend to tradition and install these sources into mingw-cross-env.
    $(INSTALL) -m644 '$(1)/gsoap/'*.c '$(1)/gsoap/'*.cpp '$(PREFIX)/$(TARGET)/share/gsoap'
endef
