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

PKG             := log4cxx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.0
$(PKG)_CHECKSUM := d79c053e8ac90f66c5e873b712bb359fd42b648d
$(PKG)_SUBDIR   := apache-log4cxx-$($(PKG)_VERSION)
$(PKG)_FILE     := apache-log4cxx-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://logging.apache.org/log4cxx/index.html
$(PKG)_URL      := http://apache.naggo.co.kr//logging/log4cxx/0.10.0/$($(PKG)_FILE)
$(PKG)_URL_2    := http://apache.mirror.cdnetworks.com//logging/log4cxx/0.10.0/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc apr-util

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
        --with-apr='$(PREFIX)/$(TARGET)' \
        --with-apr-util='$(PREFIX)/$(TARGET)' \
        CFLAGS=-D_WIN32_WINNT=0x0500 \
        CXXFLAGS=-D_WIN32_WINNT=0x0500 
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
