# This file is part of MXE.
# See index.html for further information.

PKG             := $(basename $(notdir $(lastword $(MAKEFILE_LIST))))
$(PKG)_FILE      = $(qtbase_FILE)
$(PKG)_PATCHES   = $(realpath $(sort $(wildcard $(addsuffix /qtbase-[0-9]*.patch, $(TOP_DIR)/src))))
$(PKG)_SUBDIR    = $(qtbase_SUBDIR)
$(PKG)_DEPS     := gcc qtbase

# main configure options: -platform -host-option -external-hostbindir
# further testing needed: -prefix -extprefix -hostprefix -sysroot -no-gcc-sysroot
#                         and keeping options synced with qtbase

define $(PKG)_BUILD
    $(SED) -i 's,BUILD_ON_MAC=yes,BUILD_ON_MAC=no,g' '$(1)/configure'
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
            -prefix '$(PREFIX)/$(TARGET)/$(PKG)' \
            -static \
            -release \
            -c++std c++11 \
            -platform win32-g++ \
            -host-option CROSS_COMPILE=${TARGET}- \
            -external-hostbindir '$(PREFIX)/$(TARGET)/qt5/bin' \
            -device-option PKG_CONFIG='${TARGET}-pkg-config' \
            -device-option CROSS_COMPILE=${TARGET}- \
            -force-pkg-config \
            -no-sql-{db2,ibase,mysql,oci,odbc,psql,sqlite,sqlite2,tds} \
            -no-use-gold-linker \
            -nomake examples \
            -nomake tests \
            -opensource \
            -confirm-license \
            -continue \
            -verbose

    rm -rf '$(PREFIX)/$(TARGET)/$(PKG)'
    # install qmake.exe (created by configure)
    # and generate remaining build configuration
    $(MAKE) -C '$(1).build' -j $(JOBS) \
        sub-qmake-qmake-aux-pro-install_subtargets \
        sub-src-qmake_all

    # build and install other tools
    $(MAKE) -C '$(1).build/src' -j $(JOBS) \
        sub-moc-install_subtargets \
        sub-qdbuscpp2xml-install_subtargets \
        sub-qdbusxml2cpp-install_subtargets \
        sub-qlalr-install_subtargets \
        sub-rcc-install_subtargets \
        sub-uic-install_subtargets
endef
