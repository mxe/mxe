# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := itpp
$(PKG)_WEBSITE  := http://itpp.sourceforge.net
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.1
$(PKG)_CHECKSUM := 50717621c5dfb5ed22f8492f8af32b17776e6e06641dfe3a3a8f82c8d353b877
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc blas lapack fftw

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/itpp/files/itpp/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' \
        -DCMAKE_INSTALL_PREFIX:STRING="lib/itpp" \
        -DBLAS_LIBRARIES=libblas.dll \
        '$(SOURCE_DIR)'

    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
