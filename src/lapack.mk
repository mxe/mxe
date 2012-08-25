# This file is part of MXE.
# See index.html for further information.

PKG             := lapack
$(PKG)_IGNORE   := 3.4.1
$(PKG)_CHECKSUM := 910109a931524f8dcc2734ce23fe927b00ca199f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.netlib.org/lapack/' | \
    $(SED) -n 's_.*>LAPACK, version \([0-9]\.[0-9]\.[0-9]\).*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        .
    $(MAKE) -C '$(1)/SRC' -j '$(JOBS)' install

    '$(TARGET)-gfortran' \
        -W -Wall -Werror -pedantic \
        '$(2).f' -o '$(PREFIX)/$(TARGET)/bin/test-lapack.exe' \
        -llapack
endef
