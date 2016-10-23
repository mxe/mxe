# This file is part of MXE.
# See index.html for further information.

PKG             := gdcm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.3
$(PKG)_CHECKSUM := 83b9ff0744a37b4bf8f687ed198aabea7a9dfc70
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG) 2.x/GDCM $($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := expat zlib

$(PKG)_CMAKE_OPTS :=
ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_CMAKE_OPTS := -G "MSYS Makefiles" 
  endif
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package gdcm.' >&2;
    echo $(gdcm_VERSION)
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
        ../$($(PKG)_SUBDIR)
    make -C $(1)/../.build -j $(JOBS) 
    make -C $(1)/../.build -j 1 install
endef

endif
