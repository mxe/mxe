# This file is part of MXE.
# See index.html for further information.

PKG             := json_spirit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.08
$(PKG)_CHECKSUM := d46a896991b7eb736bff2628909645d3bbaaf5cf
$(PKG)_SUBDIR   := $(PKG)_v$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)_v$($(PKG)_VERSION).zip

# The original source of this file at
# http://www.codeproject.com/KB/recipes/JSON_Spirit/json_spirit_v4.08.zip
# is behind a login screen, so I have offered to host this from my
# website
$(PKG)_URL      := http://www.hpcoders.com.au/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && \
        cmake '$(1)' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_RELEASE_POSTFIX='' \
        -DBoost_THREADAPI=win32 \
        -DPCL_SHARED_LIBS=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_apps=OFF \
        -DBUILD_examples=OFF \
        -DBUILD_global_tests=OFF \
        -DBUILD_tools=OFF \
        -DHAVE_MM_MALLOC_EXITCODE=0 \
        -DHAVE_SSE4_1_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSE3_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSE2_EXTENSIONS_EXITCODE=0 \
        -DHAVE_SSE_EXTENSIONS_EXITCODE=0
    $(MAKE) -C '$(1).build' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(1)' -j 1 VERBOSE=1
    $(MAKE) -C '$(1).build' -j 1 install VERBOSE=1
endef

$(PKG)_BUILD_SHARED =
