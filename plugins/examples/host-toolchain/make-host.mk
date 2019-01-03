# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := make-host
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.1
$(PKG)_CHECKSUM := d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589
$(PKG)_SUBDIR   := make-$($(PKG)_VERSION)
$(PKG)_FILE     := make-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://ftp.gnu.org/gnu/make/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/make/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/make/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="make-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

$(PKG)_SRCS := ar.c arscan.c commands.c default.c dir.c expand.c file.c \
               function.c getloadavg.c getopt.c getopt1.c glob/fnmatch.c \
               glob/glob.c guile.c hash.c implicit.c job.c load.c loadapi.c \
               main.c misc.c output.c read.c remake.c remote-stub.c rule.c \
               signame.c strcache.c variable.c version.c vpath.c \
               w32/compat/posixfcn.c w32/pathstuff.c w32/subproc/misc.c \
               w32/subproc/sub_proc.c w32/subproc/w32err.c w32/w32os.c

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && mkdir -p glob w32/compat w32/subproc
    cp '$(SOURCE_DIR)/config.h.W32' '$(BUILD_DIR)/config.h'

    $(foreach FILE,$($(PKG)_SRCS),\
        '$(TARGET)-gcc' \
            -mthreads -Wall -std=gnu99 -O2 -DWINDOWS32 -DHAVE_CONFIG_H \
            -I'$(SOURCE_DIR)' \
            -I'$(BUILD_DIR)' \
            -I'$(SOURCE_DIR)/glob' \
            -I'$(SOURCE_DIR)/w32/include' \
            -o '$(BUILD_DIR)/$(FILE).o' \
            -c '$(SOURCE_DIR)/$(FILE)'$(\n))

    cd '$(BUILD_DIR)' && \
        '$(TARGET)-gcc' \
            -mthreads -Wl,--subsystem,console -s \
            -o '$(BUILD_DIR)/make.exe' \
            $(addsuffix .o,$($(PKG)_SRCS)) -ladvapi32 -luser32

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) '$(BUILD_DIR)/make.exe' '$(PREFIX)/$(TARGET)/bin/make.exe'
endef

