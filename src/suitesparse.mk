# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# SuiteSparse
PKG             := suitesparse
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.0
$(PKG)_CHECKSUM := 6de027d48a573659b40ddf57c10e32b39ab034c6
$(PKG)_SUBDIR   := SuiteSparse
$(PKG)_FILE     := SuiteSparse-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.cise.ufl.edu/
$(PKG)_URL      := http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-3.4.0.tar.gz
$(PKG)_DEPS     := gcc metis
define $(PKG)_UPDATE
    wget -q -O- 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/' | \
    $(SED) -n 's,.*SuiteSparse-\([0-9]\.[0-9]\.[0-9]\)\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
     cd '$(1)' && CHOST='$(TARGET)' 
#    cd '$(1)' && CHOST='$(TARGET)' ./configure \
#        --prefix='$(PREFIX)/$(TARGET)' \
#        --static
    $(MAKE) -C '$(1)' -j '$(JOBS)' 
endef


