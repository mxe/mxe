# This file is part of MXE.
# See index.html for further information.

PKG             := openthreads
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2
$(PKG)_CHECKSUM := a45e117992f68075acfab8967e896f52495d4de0
$(PKG)_SUBDIR   := OpenThreads-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/mxedeps/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: Updates for package OpenThreads need to be written.' >&2;
    echo '$(openthreads_VERSION)'
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),FALSE,TRUE) \
        -C '$(1)/TryRunResults.cmake'\
        '$(1)'
  $(MAKE) -C '$(1).build' -j '$(JOBS)' install
endef
