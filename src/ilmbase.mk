# This file is part of MXE.
# See index.html for further information.

PKG             := ilmbase
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.0
$(PKG)_CHECKSUM := ecf815b60695555c1fbc73679e84c7c9902f4e8faa6e8000d2f905b8b86cedc7
$(PKG)_SUBDIR   := ilmbase-$($(PKG)_VERSION)
$(PKG)_FILE     := ilmbase-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.savannah.nongnu.org/releases/openexr/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.openexr.com/downloads.html' | \
    grep 'ilmbase-' | \
    $(SED) -n 's,.*/ilmbase-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build the win32 thread sources instead of the posix thread sources
    $(SED) -i 's,IlmThreadPosix\.,IlmThreadWin32.,'                   '$(1)/IlmThread/Makefile.in'
    $(SED) -i 's,IlmThreadSemaphorePosix\.,IlmThreadSemaphoreWin32.,' '$(1)/IlmThread/Makefile.in'
    $(SED) -i 's,IlmThreadMutexPosix\.,IlmThreadMutexWin32.,'         '$(1)/IlmThread/Makefile.in'
    echo '/* disabled */' > '$(1)/IlmThread/IlmThreadSemaphorePosixCompat.cpp'
    # Because of the previous changes, '--disable-threading' will not disable
    # threading. It will just disable the unwanted check for pthread.
    cd '$(1)' && $(SHELL) ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-threading \
        CONFIG_SHELL=$(SHELL) \
        SHELL=$(SHELL)
    # do the first build step by hand, because programs are built that
    # generate source files
    cd '$(1)/Half' && $(BUILD_CXX) eLut.cpp -o eLut
    '$(1)/Half/eLut' > '$(1)/eLut.h'
    cd '$(1)/Half' && $(BUILD_CXX) toFloat.cpp -o toFloat
    '$(1)/Half/toFloat' > '$(1)/toFloat.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
