# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# metis
PKG             := metis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0
$(PKG)_CHECKSUM := 580568308e1fa40e5a7a77cacbf27f865d6c01af
$(PKG)_SUBDIR   := metis-4.0
$(PKG)_FILE     := metis-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://glaros.dtc.umn.edu
$(PKG)_URL      := http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-4.0.tar.gz
$(PKG)_DEPS     := gcc
define $(PKG)_UPDATE
    wget -q -O- 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/' | \
    $(SED) -n 's,.*metis-\([0-9]\.[0-9]\)\.tar.gz,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
     cd '$(1)' && CHOST='$(TARGET)' 
#    cd '$(1)' && CHOST='$(TARGET)' ./configure \
#        --prefix='$(PREFIX)/$(TARGET)' \
#        --static
    $(MAKE) -C '$(1)' -j '$(JOBS)' 
endef


