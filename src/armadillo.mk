# This file is part of MXE.
# See index.html for further information.

PKG             := armadillo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.930.2
$(PKG)_CHECKSUM := cbd8b2b65d5af4af1e2ab8d93896cd641c27023c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/arma/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost blas lapack

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/arma/files/' | \
    $(SED) -n 's,.*/armadillo-\([0-9.]*\)[.]tar.*".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1

    # note: don't use -Werror with GCC 4.7.0 and .1
    '$(TARGET)-g++' \
        -W -Wall \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-armadillo.exe' \
        -larmadillo -llapack -lblas -lgfortran \
        -lboost_serialization-mt -lboost_thread_win32-mt -lboost_system-mt
endef

$(PKG)_BUILD_SHARED =
