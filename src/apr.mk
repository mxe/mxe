# This file is part of MXE.
# See index.html for further information.

PKG             := apr
$(PKG)_IGNORE   := 1.5%
$(PKG)_VERSION  := 1.4.2
$(PKG)_CHECKSUM := d48324efb0280749a5d7ccbb053d68545c568b4b
$(PKG)_SUBDIR   := apr-$($(PKG)_VERSION)
$(PKG)_FILE     := apr-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://mirror.apache-kr.org/apr/$($(PKG)_FILE)
$(PKG)_URL_2    := http://archive.apache.org/dist/apr/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://apr.apache.org/download.cgi' | \
    grep 'apr1.*best' |
    $(SED) -n 's,.*APR \([0-9.]*\).*,\1,p'
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --enable-static \
        ac_cv_sizeof_off_t=4 \
        ac_cv_sizeof_pid_t=4 \
        ac_cv_sizeof_size_t=4 \
        ac_cv_sizeof_ssize_t=4 \
        CFLAGS=-D_WIN32_WINNT=0x0500
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
    ln -sf '$(PREFIX)/$(TARGET)/bin/apr-1-config' '$(PREFIX)/bin/$(TARGET)-apr-1-config'
endef

$(PKG)_BUILD_SHARED =
