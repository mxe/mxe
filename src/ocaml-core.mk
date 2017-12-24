# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ocaml-core
$(PKG)_WEBSITE  := https://caml.inria.fr/
$(PKG)_DESCR    := ocaml
$(PKG)_IGNORE    = $(ocaml-native_IGNORE)
$(PKG)_VERSION   = $(ocaml-native_VERSION)
$(PKG)_CHECKSUM  = $(ocaml-native_CHECKSUM)
$(PKG)_SUBDIR    = $(ocaml-native_SUBDIR)
$(PKG)_FILE      = $(ocaml-native_FILE)
$(PKG)_URL       = $(ocaml-native_URL)
$(PKG)_URL_2     = $(ocaml-native_URL_2)
$(PKG)_DEPS     := cc bfd ocaml-flexdll ocaml-native

define $(PKG)_UPDATE
    echo $(ocaml-native_VERSION)
endef

OTHER_LIBS := win32unix str num dynlink bigarray systhreads win32graph

define $(PKG)_BUILD
    # Build native ocamlrun and ocamlc which contain the
    # filename-win32-dirsep patch.
    #
    # Note that we must build a 32 bit compiler, even on 64 bit build
    # architectures, because this compiler will try to do strength
    # reduction optimizations using its internal int type, and that must
    # match Windows' int type.    (That's what -cc and -host are for).
    cd '$(1)' && ./configure \
      -prefix '$(PREFIX)/$(TARGET)' \
      -bindir '$(PREFIX)/$(TARGET)/bin' \
      -libdir '$(PREFIX)/$(TARGET)/lib/ocaml' \
      -no-tk \
      -cc "$(BUILD_CC) -m32" \
      -no-shared-libs \
      -host '$(TARGET)' \
      -x11lib /usr/lib \
      -verbose
    $(MAKE) -C '$(1)' -j 1 core
    # Now move the working ocamlrun, ocamlc into the boot/ directory,
    # overwriting the binary versions which ship with the compiler with
    # ones that contain the filename-win32-dirsep patch.
    $(MAKE) -C '$(1)' -j 1 coreboot
    # second time, otherwise Segfault in some cases (depending on the running system?)
    $(MAKE) -C '$(1)' -j 1 coreboot
    $(MAKE) -C '$(1)' -j 1 all
    # install ocamldoc and camlp4 (non cross versions)

    ####### patch mingw include
    # Now patch utils/clflags.ml to hardcode mingw-specific include.
    $(SED) -i "s,@libdir@,$(PREFIX)/$(TARGET)/lib,g" \
        $(1)/hardcode_mingw_include.patch
    cd '$(1)' && patch -p2 < hardcode_mingw_include.patch

    ####### prepare cross build
    # Replace the compiler configuration (config/{s.h,m.h,Makefile})
    # with ones as they would be on a 32 bit Windows system.
    cp -f '$(1)/config/m-nt.h' '$(1)/config/m.h'
    cp -f $(1)/config/s-nt.h $(1)/config/s.h
    # config/Makefile is a custom one which we supply.
    rm -f $(1)/config/Makefile
    $(SED) \
      -e "s,@prefix@,$(PREFIX)/$(TARGET),g" \
      -e "s,@toolpref@,$(TARGET),g" \
      -e "s,@otherlibraries@,$(OTHER_LIBS),g" \
      < $(1)/Makefile-mingw.in > $(1)/config/Makefile
    $(SED) -i "s,@libdir@,$(PREFIX)/$(TARGET)/lib,g" $(1)/otherlibs/Makefile.shared
    # We're going to build in otherlibs/win32unix and otherlibs/win32graph
    # directories, but since they would normally only be built under
    # Windows, they only have the Makefile.nt files.  Just symlink
    # Makefile -> Makefile.nt for these cases.
    $(SED) -i "s,@libdir@,$(PREFIX)/$(TARGET)/lib,g" $(1)/otherlibs/win32unix/Makefile.nt
    $(SED) -i "s,@libdir@,$(PREFIX)/$(TARGET)/lib,g" $(1)/otherlibs/win32graph/Makefile.nt
    $(SED) -i "s,@libdir@,$(PREFIX)/$(TARGET)/lib,g" $(1)/otherlibs/systhreads/Makefile.nt
    for d in $(1)/otherlibs/win32unix \
             $(1)/otherlibs/win32graph \
             $(1)/otherlibs/bigarray \
             $(1)/otherlibs/systhreads; do \
                 ln -sf Makefile.nt $$d/Makefile; \
    done
    # Now clean the temporary files from the previous build.  This
    # will also cause asmcomp/arch.ml (etc) to be linked to the 32 bit
    # i386 versions, essentially causing ocamlopt to use the Win/i386 code
    # generator.
    $(MAKE) -C '$(1)' partialclean
    # We need to remove any .o object for make sure they are
    # recompiled later..
    cd $(1) && rm byterun/*.o

    ####### build mingw ocaml
    # Just rebuild some small bits that we need for the following
    # 'make opt' to work.  Note that 'make all' fails here.
    $(MAKE) -C '$(1)/byterun' -j 1 libcamlrun.a
    $(MAKE) -C '$(1)' -j 1 ocaml ocamlc
    $(MAKE) -C '$(1)/stdlib' -j 1
    $(MAKE) -C '$(1)/tools' -j 1 ocamlmklib
    # Build ocamlopt
    $(MAKE) -C '$(1)' -j 1 opt
    # Now build otherlibs for ocamlopt
    cd '$(1)' && \
      for i in $(OTHER_LIBS); do \
        $(MAKE) -C otherlibs/$$i -j 1 clean; \
        $(MAKE) -C otherlibs/$$i -j 1 all; \
        $(MAKE) -C otherlibs/$$i -j 1 allopt; \
    done

    ####### installation
    $(MAKE) -C '$(1)' -j 1 install
    $(MAKE) -C '$(1)' -j 1 installopt
    # Rename all the binaries to target-binary
    for f in ocamlc ocamlcp ocamlrun ocamldep ocamlmklib ocamlmktop ocamlopt \
      ocamlprof; do \
        cp -f $(PREFIX)/$(TARGET)/bin/$$f $(PREFIX)/bin/$(TARGET)-$$f; \
    done

    # test ocamlopt
    cp '$(TEST_FILE)' '$(1)/test.ml'
    cd '$(1)' && '$(TARGET)-ocamlopt' test.ml
    # test ocamlbuild from package ocaml-native, now that ocamlopt works
    mkdir '$(1)/tmp' && cp '$(TEST_FILE)' '$(1)/tmp/test.ml'
    cd '$(1)/tmp' && $(TARGET)-ocamlbuild test.native
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
