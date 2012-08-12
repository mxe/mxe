# This file is part of MXE.
# See index.html for further information.

# armadillo
PKG             := armadillo
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c9f6ddade1e0c2524b058914dd07ba0c7f402b7b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/arma/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost blas lapack

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/arma/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
    cmake . -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1

'$(TARGET)-g++' \
        -W -Wall -Werror -01 \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-armadillo.exe' \
        -larmadillo -llapack -lblas -lgfortran
        -lboost_serialization-mt -lboost_thread_win32-mt -lboost_system-mt
endef
