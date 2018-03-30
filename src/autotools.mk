# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := autotools
$(PKG)_WEBSITE  := https://en.wikipedia.org/wiki/GNU_Build_System
$(PKG)_DESCR    := Dependency package to ensure the autotools work
$(PKG)_VERSION  := 1
$(PKG)_DEPS     := libtool pkgconf
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_TYPE     := meta

define $(PKG)_BUILD_$(BUILD)
    # fail early if autotools can't autoreconf
    # 1. detect mismatches in installation locations
    # 2. ???
    (echo 'AC_INIT([mxe.cc], [1])'; \
     $(foreach PROG, autoconf automake libtool, \
         echo 'AC_PATH_PROG([$(call uc,$(PROG))], [$(PROG)])';) \
     echo 'PKG_PROG_PKG_CONFIG(0.16)'; \
     echo 'AC_OUTPUT') \
     > '$(BUILD_DIR)/configure.ac'
    cd '$(BUILD_DIR)' && autoreconf -fiv
    cd '$(BUILD_DIR)' && ./configure
endef
