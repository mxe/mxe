# Copyright (C) 2009  Mark Brand
#                     Volker Grabsch
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

# PostgreSQL
PKG             := postgresql
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.4.1
$(PKG)_CHECKSUM := e6903f0029402ef8fb12645a177204499ea5b2b7
$(PKG)_SUBDIR   := postgresql-$($(PKG)_VERSION)
$(PKG)_FILE     := postgresql-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.postgresql.org/
$(PKG)_URL      := http://ftp2.nl.postgresql.org/source/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp10.us.postgresql.org/postgresql/source/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://anoncvs.postgresql.org/cvsweb.cgi/pgsql/' | \
    grep '<option>REL' | \
    $(SED) -n 's,.*REL\([0-9][0-9_]*\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    # Since we build only client libary, use bogus tzdata to satisfy configure.
    # We have to build the shared library, but we won't install it.
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --disable-rpath \
        --without-tcl \
        --without-perl \
        --without-python \
        --without-gssapi \
        --without-krb5 \
        --without-pam \
        --without-ldap \
        --without-bonjour \
        --without-openssl \
        --without-readline \
        --without-ossp-uuid \
        --without-libxml \
        --without-libxslt \
        --with-zlib \
        --with-system-tzdata=/dev/null
    $(MAKE) -C '$(1)'/src/interfaces/libpq -j '$(JOBS)' install haslibarule= shlib=
    $(INSTALL) -m664 '$(1)/src/include/pg_config.h'    '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m664 '$(1)/src/include/postgres_ext.h' '$(PREFIX)/$(TARGET)/include/'
endef
