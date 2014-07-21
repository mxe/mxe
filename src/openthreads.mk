# This file is part of MXE.
# See index.html for further information.
PKG             := openthreads
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2
$(PKG)_CHECKSUM := a45e117992f68075acfab8967e896f52495d4de0
$(PKG)_SUBDIR   := OpenThreads-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenThreads-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://localhost/tmp-win-sources/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc 

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=ON \
        -C '$(1)/TryRunResults.cmake'\
        '$(1)'
  $(MAKE) -C '$(1).build' -j '$(JOBS)' install
endef
