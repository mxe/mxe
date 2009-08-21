# Copyright (C) 2009  Volker Grabsch <vog@notjusthosting.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# gettext
PKG             := gettext
$(PKG)_VERSION  := 0.17
$(PKG)_CHECKSUM := c51803d9f745f6ace36bd09c0486d5735ce399cf
$(PKG)_SUBDIR   := gettext-$($(PKG)_VERSION)
$(PKG)_FILE     := gettext-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.gnu.org/software/gettext/
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gettext/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gnu.org/software/gettext/' | \
    grep 'gettext-' | \
    $(SED) -n 's,.*gettext-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # native build of libiconv (used by gettext-tools)
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,libiconv)
    cd '$(1)/$(libiconv_SUBDIR)' && ./configure \
        --prefix='$(1)/libiconv' \
        --disable-shared \
        --disable-java \
        --disable-csharp \
        --disable-nls
    $(MAKE) -C '$(1)/$(libiconv_SUBDIR)' -j 1 install

    # bugfix for gettext
    # This problem will be solved in gettext >= 1.8. See:
    # http://git.savannah.gnu.org/cgit/gettext.git/commit/?id=ecad95f51a11409cc0d30b22913a8ba77d3edf1d
    $(SED) 's/O_CREAT);/O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH);/' \
        -i '$(1)/gettext-tools/src/write-catalog.c'

    # native build for gettext-tools
    cd '$(1)/gettext-tools' && ./configure \
        --disable-shared \
        --prefix='$(PREFIX)' \
        --disable-java \
        --disable-csharp \
        --disable-threads \
        --with-libiconv-prefix='$(1)/libiconv' \
        --with-included-gettext \
        --with-included-glib \
        --with-included-libcroco \
        --with-included-libxml \
        --with-included-regex \
        --without-libpth-prefix \
        --without-libncurses-prefix \
        --without-libtermcap-prefix \
        --without-libxcurses-prefix \
        --without-libcurses-prefix \
        --without-libexpat-prefix \
        --without-emacs
    $(MAKE) -C '$(1)/gettext-tools' -j '$(JOBS)' SHELL=bash
    $(MAKE) -C '$(1)/gettext-tools/src' -j 1 SHELL=bash lib_LTLIBRARIES= install-binPROGRAMS

    # cross build for gettext-runtime
    cd '$(1)/gettext-runtime' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads=win32 \
        --without-libexpat-prefix \
        --without-libxml2-prefix
    $(MAKE) -C '$(1)/gettext-runtime/intl' -j '$(JOBS)' SHELL=bash install
endef
