# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := aspell
$(PKG)_WEBSITE  := http://aspell.net/
$(PKG)_DESCR    := Aspell
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.60.6.1
$(PKG)_CHECKSUM := f52583a83a63633701c5f71db3dc40aab87b7f76b29723aeb27941eff42df6e1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gettext

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/aspell/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(LIBTOOLIZE) && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-win32-relocatable \
        --disable-curses \
        --disable-dlopen \
        --disable-pthreads \
        CPPFLAGS='-DENABLE_W32_PREFIX=1'

    # fix undefined reference to `libintl_dgettext'
    # https://github.com/mxe/mxe/pull/1210#issuecomment-178471641
    $(if $(BUILD_SHARED),\
        $(SED) -i 's#^postdeps="-#postdeps="-lintl -#g' '$(1)/libtool')

    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
