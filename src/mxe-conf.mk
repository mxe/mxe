# This file is part of MXE. See LICENSE.md for licensing information.

PKG            := mxe-conf
$(PKG)_VERSION := 1
$(PKG)_UPDATE  := echo 1
$(PKG)_TARGETS := $(BUILD) $(MXE_TARGETS)

define $(PKG)_BUILD
    # create basic non-empty directory hierarchy
    for d in bin include lib share; do \
        mkdir -p "$(PREFIX)/$(TARGET)/$$d" && \
        touch    "$(PREFIX)/$(TARGET)/$$d/.gitkeep" ; \
    done

    # install target-specific autotools config file
    # setting ac_cv_build bypasses the config.guess check in every package
    echo "ac_cv_build=$(BUILD)" > '$(PREFIX)/$(TARGET)/share/config.site'
endef

define $(PKG)_BUILD_$(BUILD)
    # install config.guess for general use
    mkdir -p '$(PREFIX)/bin'
    $(INSTALL) -m755 '$(EXT_DIR)/config.guess' '$(PREFIX)/bin/'

    # fail early if autotools can't autoreconf
    # 1. detect mismatches in installation locations
    # 2. ???
    (echo 'AC_INIT([mxe.cc], [1])'; \
     $(foreach PROG, autoconf automake libtool, \
         echo 'AC_PATH_PROG([$(call uc,$(PROG))], [$(PROG)])';) \
     echo 'PKG_PROG_PKG_CONFIG(0.16)'; \
     echo 'AC_OUTPUT') \
     > '$(1)/configure.ac'
    cd '$(1)' && autoreconf -fiv
    cd '$(1)' && ./configure

    #create script "wine" in a directory which is in PATH
    mkdir -p '$(PREFIX)/$(BUILD)/bin/'
    (echo '#!/usr/bin/env bash'; \
     echo 'exit 1'; \
    ) \
             > '$(PREFIX)/$(BUILD)/bin/wine'
    chmod 0755 '$(PREFIX)/$(BUILD)/bin/wine'
endef
