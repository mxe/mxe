# This file is part of MXE.
# See index.html for further information.

PKG             := qhull
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 60f61580e1d6fbbd28e6df2ff625c98d15b5fbc6
$(PKG)_SUBDIR   := qhull-$($(PKG)_VERSION)
$(PKG)_FILE     := qhull-$($(PKG)_VERSION)-src.tgz
$(PKG)_URL      := http://www.qhull.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.qhull.org/download/ | \
    $(SED) -n 's,.*<a href="qhull-\([0-9][0-9\.]*\)\.md5sum".*,\1,p' | \
    head -1
endef


define $(PKG)_BUILD

    cd '$(1)' && config/bootstrap.sh

    cd '$(1)' && automake

	
    # configure
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
    	#--disable-dynamic \
        #--enable-static \
    	#--enable-openmp

    # make
    $(MAKE) -C '$(1)' libqhull 

    # install 
    #$(MAKE) -C '$(1)' install	

endef

