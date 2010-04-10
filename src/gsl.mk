# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# gsl
PKG             := gsl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14
$(PKG)_CHECKSUM := e1a600e4fe359692e6f0e28b7e12a96681efbe52
$(PKG)_SUBDIR   := gsl-$($(PKG)_VERSION)
$(PKG)_FILE     := gsl-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.gnu.org/software/gsl
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/gsl/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gnu.org/software/gsl' | \
    grep -o "GSL-[0-9.]*" | \
    $(SED) -e s/GSL-//g -e s/'.$'//g | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
