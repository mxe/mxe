# This file is part of MXE.
# See index.html for further information.

PKG             := armadillo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.550.1
$(PKG)_CHECKSUM := f44e85a4cc2d1631339ef974464730d952f3b2bf9141eedfc42ed4ace9148260
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/arma/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc blas boost lapack

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/arma/files/' | \
    $(SED) -n 's,.*/armadillo-\([0-9.]*\)[.]tar.*".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_SHARED),YES,NO) \
        -DARMA_USE_WRAPPER=false
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1

    # note: don't use -Werror with GCC 4.7.0 and .1
    '$(TARGET)-g++' \
        -W -Wall \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-armadillo.exe' \
        -larmadillo -llapack -lblas -lgfortran -lquadmath \
        -lboost_serialization-mt -lboost_thread_win32-mt -lboost_system-mt
endef
