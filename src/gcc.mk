# TDM-GCC
# http://www.tdragon.net/recentgcc/

PKG            := gcc
$(PKG)_VERSION := 4.3.2-tdm-2
$(PKG)_SUBDIR  := .
$(PKG)_FILE    := gcc-$($(PKG)_VERSION)-srcbase.zip
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/tdm-gcc/$($(PKG)_FILE)
$(PKG)_DEPS    := pkg_config mingwrt w32api binutils gcc-gmp gcc-mpfr gcc-core gcc-g++ gcc-objc gcc-fortran

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=200665&package_id=238347' | \
    grep 'gcc-' | \
    $(SED) -n 's,.*gcc-\([4-9][^>]*\)-srcbase\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # unpack GCC
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-core)
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-g++)
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-objc)
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-fortran)
    # apply TDM patches to GCC
    cd '$(1)/$(gcc-core_SUBDIR)' && \
        for p in '$(1)'/*.patch; do \
            patch -p1 < "$$p"; \
        done
    # unpack support libraries
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-gmp)
    mv '$(1)/$(gcc-gmp_SUBDIR)' '$(1)/$(gcc-core_SUBDIR)/gmp'
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-mpfr)
    mv '$(1)/$(gcc-mpfr_SUBDIR)' '$(1)/$(gcc-core_SUBDIR)/mpfr'
    # build
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(1)/$(gcc-core_SUBDIR)/configure' \
        --target='$(TARGET)' \
        --prefix='$(PREFIX)' \
        --enable-languages='c,c++,objc,fortran' \
        --enable-version-specific-runtime-libs \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared \
        --without-x \
        --enable-threads=win32 \
        --disable-win32-registry \
        --enable-sjlj-exceptions
    $(MAKE) -C '$(1)/build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/build' -j 1 install
endef
