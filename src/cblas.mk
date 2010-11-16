# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# cblas
PKG             := cblas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 
$(PKG)_CHECKSUM := a8a765ebb8d753c7ad161ccd9191be42d3dc8bd9
$(PKG)_SUBDIR   := CBLAS
$(PKG)_FILE     := cblas.tgz
$(PKG)_WEBSITE  := http://www.netlib.org/
$(PKG)_URL      := http://www.netlib.org/blas/blast-forum/cblas.tgz
$(PKG)_DEPS     := gcc


define $(PKG)_BUILD

    cp $(1)/Makefile.LINUX $(1)/Makefile.WIN32
    $(SED) -i 's,CBDIR = $$(HOME)/CBLAS,CBDIR = $(1),g'   '$(1)/Makefile.WIN32'
    $(SED) -i 's,FC = g77,FC = $(TARGET)-gfortran,g'   '$(1)/Makefile.WIN32'
    ln -s $(1)/Makefile.WIN32 $(1)/Makefile.in
    mkdir $(1)/WIN32
    make  -C $(1) alllib
    cd $(1) && $(TARGET)-ar cr libcblas.a src/*.o 
    	
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m664 '$(1)/libcblas.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m664 '$(1)/src/cblas.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m664 '$(1)/src/cblas_f77.h' '$(PREFIX)/$(TARGET)/include/'

endef


