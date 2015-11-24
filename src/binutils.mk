# This file is part of MXE.
# See index.html for further information.

PKG             := binutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.25.1
$(PKG)_CHECKSUM := b5b14added7d78a8d1ca70b5cb75fef57ce2197264f4f5835326b0df22ac9f22
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(PHASE_1_TARGETS) $(PHASE_2_TARGETS) $(MXE_TARGETS)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/binutils/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="binutils-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

# list of programs to symlink
$(PKG)_PROGS := addr2line ar as c++filt dlltool dllwrap elfedit gprof \
                ld ld.bfd nm objcopy objdump ranlib readelf size strings \
                strip windmc windres

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --target='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)' \
        --disable-multilib \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared \
        --disable-werror
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    rm -f $(addprefix $(PREFIX)/$(TARGET)/bin/,$($(PKG)_PROGS))
endef

# symlink previous phases
define $(PKG)_BUILD_SYMLINK_PHASE
    $(foreach PKG,$($(PKG)_PROGS),\
        ln -sf '$(PREFIX)/bin/$(call GET_PHASE_$(1)_TARGET,$(TARGET))-$(PKG)' \
               '$(PREFIX)/bin/$(TARGET)-$(PKG)';)
endef

# ld wrapper for packages that call ld directly
define $(PKG)_BUILD_LD_WRAPPER
    rm '$(PREFIX)/bin/$(TARGET)-ld'
    (echo '#!/bin/sh'; \
     echo 'exec "$(PREFIX)/bin/$(call GET_PHASE_1_TARGET,$(TARGET))-ld" "$$@" \
                    -L$(PREFIX)/$(call GET_PHASE_2_TARGET,$(TARGET))/lib \
                    -L$(PREFIX)/$(TARGET)/lib' \
    ) > '$(PREFIX)/bin/$(TARGET)-ld'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-ld'
endef

$(foreach TARGET,$(PHASE_2_TARGETS), \
    $(eval $(PKG)_BUILD_$(TARGET) := $$(call $(PKG)_BUILD_SYMLINK_PHASE,1)) \
    $(eval $(PKG)_FILE_$(TARGET)  :=))
$(foreach TARGET,$(MXE_TARGETS), \
    $(eval $(PKG)_BUILD_$(TARGET) := $$(call $(PKG)_BUILD_SYMLINK_PHASE,2) \
                                     $$($(PKG)_BUILD_LD_WRAPPER)) \
    $(eval $(PKG)_FILE_$(TARGET)  :=))

$(PKG)_BUILD_$(BUILD) :=
