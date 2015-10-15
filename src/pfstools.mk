# This file is part of MXE.
# See index.html for further information.

PKG             := pfstools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := 5e109d09f0c02cebf6800e04fc56851975f5d5e92d5a4ae626e31b58b347ff71
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/pfstools/files/pfstools/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

# Note: all the external dependencies are used for the tools, but we
# only want the library so we don't need them.
define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake '$(1)' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
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
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-pfstools.exe' \
        `'$(TARGET)-pkg-config' pfs --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
