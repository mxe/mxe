# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mpfr
$(PKG)_WEBSITE  := https://www.mpfr.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.2
$(PKG)_CHECKSUM := 1d3be708604eae0e42d578ba93b390c2a145f17743a744d8f3f8c2ad5855a38a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mpfr.org/mpfr-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc gmp

$(PKG)_DEPS_$(BUILD) := gmp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.mpfr.org/mpfr-current/#download' | \
    grep 'mpfr-' | \
    $(SED) -n 's,.*mpfr-\([0-9][^<]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads=win32 \
        --with-gmp-include='$(PREFIX)/$(TARGET)/include/'
        --with-gmp-lib='$(PREFIX)/$(TARGET)/lib/'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    # build runtime tests to verify toolchain components
    -$(MAKE) -C '$(1)' -j '$(JOBS)' check -k
    rm -rf '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests'
    cp -R '$(1)/tests' '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests'
    (printf 'date /t >  all-tests-$(PKG)-$($(PKG)_VERSION).txt\r\n'; \
     printf 'time /t >> all-tests-$(PKG)-$($(PKG)_VERSION).txt\r\n'; \
     printf 'set PATH=..\\;%%PATH%%\r\n'; \
     printf 'for /R %%%%f in (*.exe) do %%%%f || echo %%%%f fail >> all-tests-$(PKG)-$($(PKG)_VERSION).txt\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests/all-tests-$(PKG)-$($(PKG)_VERSION).bat'
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
