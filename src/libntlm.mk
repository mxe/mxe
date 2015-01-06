# This file is part of MXE.
# See index.html for further information.

PKG             := libntlm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4
$(PKG)_CHECKSUM := b15c9ccbd3829154647b3f9d6594b1ffe4491b6f
$(PKG)_SUBDIR   := libntlm-$($(PKG)_VERSION)
$(PKG)_FILE     := libntlm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.nongnu.org/libntlm/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/gitweb/?p=libntlm.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
