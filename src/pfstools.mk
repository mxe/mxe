# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pfstools
$(PKG)_WEBSITE  := https://pfstools.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.4
$(PKG)_CHECKSUM := 4a6c1880193d3d1924d98b8dc2d2fe25827e7b2508823dc38f535653a4fd9942
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/pfstools/files/pfstools/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

# Note: all the external dependencies are used for the tools, but we
# only want the library so we don't need them.
define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' '$(1)' \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        -DWITH_OpenEXR=false \
        -DWITH_ImageMagick=false \
        -DWITH_NetPBM=false \
        -DWITH_TIFF=false \
        -DWITH_QT=false \
        -DWITH_pfsglview=false \
        -DWITH_MATLAB=false \
        -DWITH_Octave=false \
        -DWITH_FFTW=false \
        -DWITH_GSL=false \
        -DWITH_OpenCV=false
    $(MAKE) -C '$(1).build/src/pfs' -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-g++' \
        -Wall -Wextra -Werror \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-pfstools.exe' \
        `'$(TARGET)-pkg-config' pfs --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
