# This file is part of MXE.
# See index.html for further information.

PKG             := gsoap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.22
$(PKG)_CHECKSUM := e66bbdeaa6b5bdcb11de5141e1f17343a023c5c4
$(PKG)_SUBDIR   := gsoap-$(call SHORT_PKG_VERSION,$(PKG))
$(PKG)_FILE     := gsoap_$($(PKG)_VERSION).zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/gsoap2/gSOAP/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls libgcrypt libntlm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/gsoap2/files/gSOAP/' | \
    $(SED) -n 's,.*gsoap_\([0-9][^>]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # avoid reconfiguration
    cd '$(1)' && touch configure config.h.in

    # Native build to get tools wsdl2h and soapcpp2
    cd '$(1)' && ./configure

    # Work around parallel build problem
    $(MAKE) -C '$(1)'/gsoap/src -j '$(JOBS)' soapcpp2_yacc.h
    $(MAKE) -C '$(1)'/gsoap -j '$(JOBS)'

    # Install the native tools manually
    $(INSTALL) -m755 '$(1)'/gsoap/wsdl/wsdl2h  '$(PREFIX)/bin/$(TARGET)-wsdl2h'
    $(INSTALL) -m755 '$(1)'/gsoap/src/soapcpp2 '$(PREFIX)/bin/$(TARGET)-soapcpp2'

    $(MAKE) -C '$(1)' -j '$(JOBS)' clean

    # fix hard-coded gnutls dependencies
    $(SED) -i "s/-lgnutls/`'$(TARGET)-pkg-config' --libs-only-l gnutls`/g;" '$(1)/configure'
    $(SED) -i "s^-lgpg-error^`'$(TARGET)-gpg-error-config' --libs`^g;" '$(1)/configure'

    # the cross build will need soapcpp2, not soapcpp2.exe
    $(SED) -i "s,^\(SOAP = \$$(top_builddir)/gsoap/src/soapcpp2\)\$$(EXEEXT)$$,\1,;" '$(1)/gsoap/wsdl/Makefile.in'

    # Build for mingw. Static by default.
    # Prevent undefined reference to _rpl_malloc.
    # http://groups.google.com/group/ikarus-users/browse_thread/thread/fd1d101eac32633f
    cd '$(1)' && ac_cv_func_malloc_0_nonnull=yes ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-gnutls \
        CPPFLAGS='-DWITH_NTLM -DSOAP_SSLv3=0x40'

    # Building for mingw requires native soapcpp2
    ln -sf '$(PREFIX)/bin/$(TARGET)-soapcpp2' '$(1)/gsoap/src/soapcpp2'

    # Work around parallel build problem
    $(MAKE) -C '$(1)'/gsoap/src -j '$(JOBS)' soapcpp2_yacc.h AR='$(TARGET)-ar'
    $(MAKE) -C '$(1)' -j '$(JOBS)' AR='$(TARGET)-ar'

    $(MAKE) -C '$(1)' -j '$(JOBS)' install
    # Apparently there is a tradition of compiling gsoap source files into applications.
    # Since we linked dom.cpp and dom.c into the libraries, this should not be necessary.
    # But we bend to tradition and install these sources into MXE.
    $(INSTALL) -m644 '$(1)/gsoap/'*.c '$(1)/gsoap/'*.cpp '$(PREFIX)/$(TARGET)/share/gsoap'
endef

$(PKG)_BUILD_SHARED =
