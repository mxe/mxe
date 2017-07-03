# This file is part of MXE.
# See index.html for further information.

PKG             := graphviz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.38.0
$(PKG)_CHECKSUM := 81aa238d9d4a010afa73a9d2a704fc3221c731e1e06577c2ab3496bdef67859e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.graphviz.org/pub/graphviz/stable/SOURCES/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    cd '$(1)/cmd/lefty' && $(TARGET)-windres -l 0x409 -Iws/mswin32 -DNDEBUG -Ocoff -o lefty.res ws/mswin32/lefty.rc
    cd '$(1)/lib/gvpr' && make mkdefs
    cd '$(1)' && ./configure \
	--host='$(TARGET)' \
	--prefix='$(PREFIX)/$(TARGET)' \
	--without-gdk-pixbuf --with-mylibgd --disable-static --disable-shared --disable-swig --without-x  --disable-tcl \
	--without-ipsepcola --disable-ltdl --without-gtk --without-gtkgl --disable-io --with-ortho=no --disable-sfdp
    $(MAKE) -C '$(1)' -j '$(JOBS)' V=1 'CFLAGS=-I../../libltdl -g -DR_OK=4'
    $(MAKE) -C '$(1)/lib' install
endef
