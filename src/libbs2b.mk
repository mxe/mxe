# This file is part of MXE.
# See index.html for further information.

PKG             := libbs2b
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.0
$(PKG)_CHECKSUM := 4799974becdeeedf0db00115bc63f60ea3fe4b25f1dfdb6903505839a720e46f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/bs2b/libbs2b/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/bs2b/files/libbs2b/' | \
    $(SED) -n 's,.*<a href="/projects/bs2b/files/libbs2b/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        ac_cv_func_malloc_0_nonnull=yes
    # The ac_cv_func_malloc_0_nonnull=yes is needed because the configure
    # check tries to run a program.
    $(MAKE) -C '$(1)' -j '$(JOBS)' LDFLAGS='-no-undefined' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(1)' -j 1 install LDFLAGS='-no-undefined' $(MXE_DISABLE_CRUFT)
endef