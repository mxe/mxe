# xmlwrapp
# http://sourceforge.net/projects/xmlwrapp/

PKG            := xmlwrapp
$(PKG)_VERSION := 0.6.0
$(PKG)_SUBDIR  := xmlwrapp-$($(PKG)_VERSION)
$(PKG)_FILE    := xmlwrapp-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/xmlwrapp/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc libxml2 libxslt

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=142403&package_id=156331' | \
    grep 'xmlwrapp-' | \
    $(SED) -n 's,.*xmlwrapp-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,.*/usr/include.*,,' -i '$(1)/configure.pl'
    EXSLT_LIBS=`$(TARGET)-pkg-config libexslt --libs | $(SED) 's,-L[^ ]*,,g'` \
    $(SED) "s,-lxslt -lexslt,$$EXSLT_LIBS," -i '$(1)/configure.pl'
    $(SED) 's,"ranlib",$$ENV{"RANLIB"} || "ranlib",g' -i '$(1)/tools/cxxflags'
    cd '$(1)' && \
        CXX='$(TARGET)-g++' \
        AR='$(TARGET)-ar' \
        RANLIB='$(TARGET)-ranlib' \
        CXXFLAGS="-ffriend-injection `$(PREFIX)/$(TARGET)/bin/xml2-config --cflags`" \
        ./configure.pl \
            --disable-shared \
            --prefix='$(PREFIX)/$(TARGET)' \
            --xml2-config='$(PREFIX)/$(TARGET)/bin/xml2-config' \
            --xslt-config='$(PREFIX)/$(TARGET)/bin/xslt-config' \
            --disable-examples
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
