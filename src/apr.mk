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
#
# Type sizes
#
# Sometimes wine has an emulation environment which runs conf tests,
# unfortunately these return like a 4^M, not 4 which breaks all the 
# configure script logic.
#    ac_cv_sizeof_off_t=4
#    ac_cv_sizeof_pid_t=4 
#    ac_cv_sizeof_size_t=4
#    ac_cv_sizeof_ssize_t=4

PKG             := apr
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.2
$(PKG)_CHECKSUM := d48324efb0280749a5d7ccbb053d68545c568b4b
$(PKG)_SUBDIR   := apr-$($(PKG)_VERSION)
$(PKG)_FILE     := apr-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://apr.apache.org/
$(PKG)_URL      := http://mirror.apache-kr.org/apr/$($(PKG)_FILE)
$(PKG)_URL_2    := http://apache.mirror.cdnetworks.com/apr/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

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
        ac_cv_sizeof_off_t=4 \
        ac_cv_sizeof_pid_t=4 \
        ac_cv_sizeof_size_t=4 \
        ac_cv_sizeof_ssize_t=4 \
        CFLAGS=-D_WIN32_WINNT=0x0500 \
        LDFLAGS=-no-undefined
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
