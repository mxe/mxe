# This file is part of MXE.
# See index.html for further information.

PKG             := portaudio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 19_20140130
$(PKG)_CHECKSUM := 526a7955de59016a06680ac24209ecb6ce05527d
$(PKG)_SUBDIR   := portaudio
$(PKG)_FILE     := pa_stable_v$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.portaudio.com/archives/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.portaudio.com/download.html' | \
    $(SED) -n 's,.*pa_stable_v\([0-9][^>]*\)\.tgz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    # libtool looks for a pei* format when linking shared libs
    # apparently there's no real difference b/w pei and pe
    # so we set the libtool cache variables
    # https://sourceware.org/cgi-bin/cvsweb.cgi/src/bfd/libpei.h?annotate=1.25&cvsroot=src
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-host_os=mingw \
        --with-winapi=@portaudio-winapi@ \
        --with-dxdir=$(PREFIX)/$(TARGET) \
        ac_cv_path_AR=$(TARGET)-ar \
        $(if $(BUILD_SHARED),\
            lt_cv_deplibs_check_method='file_magic file format (pe-i386|pe-x86-64)' \
            lt_cv_file_magic_cmd='$$OBJDUMP -f')
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(if $(BUILD_STATIC),SHARED_FLAGS=) TESTS=
    $(MAKE) -C '$(1)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-portaudio.exe' \
        `'$(TARGET)-pkg-config' portaudio-2.0 --cflags --libs`
endef

$(PKG)_WINAPI_MINGW_ORG = wmme,directx,wasapi,wdmks
$(PKG)_WINAPI_MINGW_W64 = wmme,directx

$(PKG)_BUILD_i686-pc-mingw32    = $(subst @portaudio-winapi@,$($(PKG)_WINAPI_MINGW_ORG),$($(PKG)_BUILD))
$(PKG)_BUILD_i686-w64-mingw32   = $(subst @portaudio-winapi@,$($(PKG)_WINAPI_MINGW_W64),$($(PKG)_BUILD))
$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @portaudio-winapi@,$($(PKG)_WINAPI_MINGW_W64),$($(PKG)_BUILD))
