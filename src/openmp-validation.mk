# This file is part of MXE.
# See index.html for further information.

PKG             := openmp-validation
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1
$(PKG)_CHECKSUM := 98e33b0d80a4e572c995cd40f50cce2c124d9465
$(PKG)_SUBDIR   := OpenMP$($(PKG)_VERSION)_Validation
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://web.cs.uh.edu/~openuh/download/packages/$($(PKG)_FILE)
$(PKG)_URL_2    :=
$(PKG)_DEPS     := gcc libgomp

define $(PKG)_UPDATE
    echo 'TODO: Updates for package openmp-validation need to be written.' >&2;
    echo $(openmp-validation_VERSION)
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        RUNTEST_OPTIONS='--norun' \
        EXE_SUFFIX='.exe' \
        CC='$(TARGET)-gcc' \
        FC='$(TARGET)-gfortran' \
        ctest ftest

    # execute validation tests on host - perl testsuite doesn't
    # work on windows (perl runtest.pl --nocompile --lang=c testlist-c.txt)
    # so run $(PREFIX)/$(TARGET)/bin/$(PKG)-tests/all-tests-openmp-validation.bat

    mkdir -p '$(PREFIX)/$(TARGET)/bin'
    rm -rf '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests'
    cp -rv '$(1)' '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests'
endef
