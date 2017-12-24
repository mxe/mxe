# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libltdl
$(PKG)_WEBSITE  := https://www.gnu.org/software/libtool/manual/html_node/Using-libltdl.html#Using-libltdl
$(PKG)_DESCR    := GNU Libtool Library (libltdl)
$(PKG)_IGNORE    = $(libtool_IGNORE)
$(PKG)_VERSION   = $(libtool_VERSION)
$(PKG)_CHECKSUM  = $(libtool_CHECKSUM)
$(PKG)_SUBDIR    = $(libtool_SUBDIR)
$(PKG)_FILE      = $(libtool_FILE)
$(PKG)_URL       = $(libtool_URL)
$(PKG)_DEPS     := cc dlfcn-win32

define $(PKG)_UPDATE
    echo $(libtool_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)/libltdl' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-ltdl-install
    $(MAKE) -C '$(1)/libltdl' -j '$(JOBS)'
    $(MAKE) -C '$(1)/libltdl' -j 1 install
endef
