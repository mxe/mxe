# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mpc
$(PKG)_WEBSITE  := http://www.multiprecision.org/
$(PKG)_DESCR    := GNU MPC
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2
$(PKG)_CHECKSUM := b561f54d8a479cee3bc891ee52735f18ff86712ba30f036f8b8537bae380c488
$(PKG)_SUBDIR   := mpc-$($(PKG)_VERSION)
$(PKG)_FILE     := mpc-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/mpc/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.debian.org/debian/pool/main/m/mpclib/mpclib_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc gmp mpfr

$(PKG)_DEPS_$(BUILD) := gmp mpfr

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gforge.inria.fr/scm/viewvc.php/tags/?root=mpc&sortby=date' | \
    $(SED) -n 's,.*<a name="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp='$(PREFIX)/$(TARGET)/' \
        --with-mpfr='$(PREFIX)/$(TARGET)/'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_$(BUILD))
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
