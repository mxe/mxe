# This file is part of MXE.
# See index.html for further information.

PKG             := pstoedit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.61
$(PKG)_CHECKSUM := 426f3746ecb441caa0db401d5880e1ac04a399d5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/pstoedit/files/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := gcc 
### libemf libming ###

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package pstoedit.' >&2;
    echo $(pstoedit_VERSION)
endef

define $(PKG)_BUILD
    #cd '$(1)' && tar xvf '$(1)'/../../pkg/libemf-1.0.7.src.tar.gz

    cd '$(1)' && autoreconf
    mkdir '$(1)/.build'

    cd '$(1)/.build' && '../configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static --disable-shared \
         --without-emf

	#--without-libplot --without-swf --without-magick

        #--with-libemf-src=DIR \
        #--with-libemf-src=DIR


    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

