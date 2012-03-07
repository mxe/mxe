# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# lapack
PKG             := lapack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.0
$(PKG)_CHECKSUM := 910109a931524f8dcc2734ce23fe927b00ca199f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_WEBSITE  := http://www.netlib.org/$(PKG)/
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.netlib.org/lapack/' | \
    $(SED) -n 's_.*>LAPACK, version \([0-9]\.[0-9]\.[0-9]\).*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        .
    $(MAKE) -C '$(1)/SRC' -j '$(JOBS)' install
endef
