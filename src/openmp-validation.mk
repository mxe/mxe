# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openmp-validation
$(PKG)_WEBSITE  := https://github.com/uhhpctools/omp-validation
$(PKG)_DESCR    := OpenMP Validation Suite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := ff8cf0c
$(PKG)_CHECKSUM := 9a86e52c2901488c5af87a83bb771818ea1650c3aec79cb4b5aa5b8f6888533f
$(PKG)_GH_CONF  := uhhpctools/omp-validation/branches/master
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' \
        RUNTEST_OPTIONS='--norun' \
        EXE_SUFFIX='.exe' \
        CC='$(TARGET)-gcc' \
        FC='$(TARGET)-gfortran' \
        ctest ftest

    # execute validation tests on host - perl testsuite doesn't
    # work on windows (perl runtest.pl --nocompile --lang=c testlist-c.txt)
    # so run $(PREFIX)/$(TARGET)/bin/openmp-validation-tests/all-tests-openmp-validation.bat

    mkdir -p '$(PREFIX)/$(TARGET)/bin'
    rm -rf '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests'
    cp -rv '$(SOURCE_DIR)' '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests'
endef
