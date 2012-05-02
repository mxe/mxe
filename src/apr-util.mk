# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Special flags
#
# -no-undefined
#
# Can't find any documentation on this option 
# (--no-undefined is there, but this aint!)
# Anyway, it bombs when gcc tries to use it, 
# but seems to help libtool at the final
# linking stage. If its not there, then 
# mingw aborts with unfound symbol errors.
# That too is a problem, and maybe should 
# resolved better than just by saying
# -no-undefined.

PKG             := apr-util
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.10
$(PKG)_CHECKSUM := f5aaf15542209fee479679299dc4cb1ac0924a59
$(PKG)_SUBDIR   := apr-util-$($(PKG)_VERSION)
$(PKG)_FILE     := apr-util-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://apr.apache.org/
$(PKG)_URL      := http://mirror.apache-kr.org/apr/$($(PKG)_FILE)
$(PKG)_URL_2    := http://apache.mirror.cdnetworks.com/apr/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv apr

#define $(PKG)_UPDATE
#    wget -q -O- 'http://www.ijg.org/' | \
#    $(SED) -n 's,.*jpegsrc\.v\([0-9][^>]*\)\.tar.*,\1,p' | \
#    head -1
#endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --enable-static \
        --without-pgsql \
        --without-sqlite2 \
        --without-sqlite3 \
        --with-apr='$(PREFIX)/$(TARGET)' \
        CFLAGS=-D_WIN32_WINNT=0x0500 \
        LDFLAGS=-no-undefined
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
