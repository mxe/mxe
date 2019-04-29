# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := exiv2
$(PKG)_WEBSITE  := https://www.exiv2.org/
$(PKG)_DESCR    := Exiv2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.25
$(PKG)_CHECKSUM := c80bfc778a15fdb06f71265db2c3d49d8493c382e516cb99b8c9f9cbde36efa4
$(PKG)_SUBDIR   := exiv2-$($(PKG)_VERSION)
$(PKG)_FILE     := exiv2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.exiv2.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat gettext mman-win32 zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.exiv2.org/download.html' | \
    grep 'href="exiv2-' | \
    $(SED) -n 's,.*exiv2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # libtool looks for a pei* format when linking shared libs
    # apparently there's no real difference b/w pei and pe
    # so we set the libtool cache variables
    # https://sourceware.org/cgi-bin/cvsweb.cgi/src/bfd/libpei.h?annotate=1.25&cvsroot=src
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-visibility \
        --disable-nls \
        --with-expat \
        LIBS='-lmman' \
        $(if $(BUILD_SHARED),\
            lt_cv_deplibs_check_method='file_magic file format (pe-i386|pe-x86-64)' \
            lt_cv_file_magic_cmd='$$OBJDUMP -f')
    $(MAKE) -C '$(1)/xmpsdk/src' -j '$(JOBS)'
    $(MAKE) -C '$(1)/src'        -j '$(JOBS)' install-lib
endef
