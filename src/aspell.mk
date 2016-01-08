# This file is part of MXE.
# See index.html for further information.

PKG             := aspell
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.60.6.1
$(PKG)_CHECKSUM := f52583a83a63633701c5f71db3dc40aab87b7f76b29723aeb27941eff42df6e1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc dlfcn-win32

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/aspell/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-win32-relocatable \
        --disable-curses \
        --disable-nls

    # libtool misses some dependency libs and there's no lt_cv* etc. options
    # can be removed after 0.60.6.1 if recent libtool et al. is used
    $(if $(BUILD_SHARED),\
        $(SED) -i 's#^postdeps="-#postdeps="-ldl -lpthread -#g' '$(1)/libtool')

    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
