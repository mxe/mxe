# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# cblas
PKG             := cblas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := a8a765ebb8d753c7ad161ccd9191be42d3dc8bd9
$(PKG)_SUBDIR   := CBLAS
$(PKG)_FILE     := $(PKG).tgz
$(PKG)_WEBSITE  := http://www.netlib.org/blas/
$(PKG)_URL      := http://www.netlib.org/blas/blast-forum/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    cp '$(1)/Makefile.LINUX' '$(1)/Makefile.MINGW32'
    $(SED) -i 's,CBDIR =.*,CBDIR = $(1),g'         '$(1)/Makefile.MINGW32'
    $(SED) -i 's,FC =.*,FC = $(TARGET)-gfortran,g' '$(1)/Makefile.MINGW32'
    $(SED) -i 's, make , $(MAKE) ,g'               '$(1)/Makefile'
    ln -s '$(1)/Makefile.MINGW32' '$(1)/Makefile.in'
    mkdir '$(1)/MINGW32'
    $(MAKE) -C '$(1)' -j '$(JOBS)' alllib
    cd '$(1)' && $(TARGET)-ar cr libcblas.a src/*.o

    $(INSTALL) -d                           '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libcblas.a'      '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d                           '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/src/cblas.h'     '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/src/cblas_f77.h' '$(PREFIX)/$(TARGET)/include/'
endef
