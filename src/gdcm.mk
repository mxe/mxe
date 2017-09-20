# This file is part of MXE.
# See index.html for further information.

PKG             := gdcm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.2
$(PKG)_CHECKSUM := 5462c7859e01e5d5d0fb86a19a6c775484a6c44abd8545ea71180d4c41bf0f89
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)%202.x/GDCM%20$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := expat zlib

$(PKG)_CMAKE_OPTS :=
ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_CMAKE_OPTS := -G "MSYS Makefiles" 
  endif
endif

define $(PKG)_UPDATE
    wget -q -O- 'https://sourceforge.net/projects/gdcm/files/gdcm%202.x/' | \
         sed -n 's_.*Download gdcm-\([0-9\.]*\)\.tar\.gz.*_\1_ip'
endef

ifeq ($(MXE_SYSTEM),msvc)
define $(PKG)_BUILD
    mkdir '$(1)/../.build'
    cd '$(1)/../.build' && cmake \
        -G "NMake Makefiles" \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'  \
        -DGDCM_BUILD_SHARED_LIBS:BOOL=TRUE \
        -DGDCM_USE_SYSTEM_ZLIB:BOOL=TRUE \
	-DGDCM_USE_SYSTEM_EXPAT:BOOL=TRUE \
        -DGDCM_BUILD_DOCBOOK_MANPAGES:BOOL=OFF \
        ../$($(PKG)_SUBDIR)
    cd '$(1)/../.build' && \
        env -u MAKE -u MAKEFLAGS nmake && \
        env -u MAKE -u MAKEFLAGS nmake install
endef
else
define $(PKG)_BUILD
    mkdir '$(1)/../.build'
    cd '$(1)/../.build' && cmake \
        $($(PKG)_CMAKE_OPTS) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'  \
        -DGDCM_BUILD_SHARED_LIBS:BOOL=TRUE \
        -DGDCM_BUILD_DOCBOOK_MANPAGES:BOOL=OFF \
        ../$($(PKG)_SUBDIR)
    make -C $(1)/../.build -j $(JOBS) 
    make -C $(1)/../.build -j 1 install
endef

endif
