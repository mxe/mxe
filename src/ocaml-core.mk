# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# zlib
PKG				:= ocaml-core
$(PKG)_IGNORE	:=
$(PKG)_CHECKSUM := 05125da055d39dd6fe8fe5c0155b2e9f55c10dfd
$(PKG)_SUBDIR	:= ocaml-$($(PKG)_VERSION)
$(PKG)_FILE		:= ocaml-$($(PKG)_VERSION).tar.gz
$(PKG)_URL		:= http://caml.inria.fr/pub/distrib/ocaml-3.12/$($(PKG)_FILE)
$(PKG)_DEPS		:= gcc ocaml-flexdll

define $(PKG)_UPDATE
	wget -q -O- 'http://caml.inria.fr/pub/distrib/ocaml-3.12' | \
	$(SED) -n 's,.*ocaml-\([0-9][^>]*\)\.tar.*,\1,ip' | \
	tail -1
endef


OTHER_LIBS := win32unix str num dynlink bigarray systhreads win32graph

define $(PKG)_BUILD
	# Build native ocamlrun and ocamlc which contain the
	# filename-win32-dirsep patch.
	#
	# Note that we must build a 32 bit compiler, even on 64 bit build
	# architectures, because this compiler will try to do strength
	# reduction optimizations using its internal int type, and that must
	# match Windows' int type.	(That's what -cc and -host are for).
	cd '$(1)' && ./configure \
	  -prefix '$(PREFIX)/$(TARGET)' \
	  -bindir '$(PREFIX)/$(TARGET)/bin' \
	  -libdir '$(PREFIX)/$(TARGET)/lib/ocaml' \
	  -no-tk \
	  -cc "gcc -m32" \
	  -no-shared-libs \
	  -host '$(TARGET)' \
	  -x11lib /usr/lib \
	  -verbose
	$(MAKE) -C '$(1)' world
	# Now move the working ocamlrun, ocamlc into the boot/ directory,
	# overwriting the binary versions which ship with the compiler with
	# ones that contain the filename-win32-dirsep patch.
	$(MAKE) -C '$(1)' coreboot

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
	  -e "s,@target2@,$(TARGET)-,g" \
	  -e "s,@prefix@,$(PREFIX)/$(TARGET),g" \
	  -e "s,@bindir@,$(PREFIX)/$(TARGET)/bin,g" \
	  -e "s,@libdir2@,$(PREFIX)/$(TARGET)/lib,g" \
	  -e "s,@libdir@,$(PREFIX)/$(TARGET)/lib/ocaml,g" \
	  -e "s,@otherlibraries@,$(OTHER_LIBS),g" \
	  -e "s,@flexdir@,$(PREFIX)/$(TARGET)/include,g" \
	  < $(1)/Makefile-mingw.in > $(1)/config/Makefile
	$(SED) -i "s,@libdir@,$(PREFIX)/$(TARGET)/lib,g" $(1)/otherlibs/str/Makefile
	$(SED) -i "s,@libdir@,$(PREFIX)/$(TARGET)/lib,g" $(1)/otherlibs/num/Makefile
	# We're going to build in otherlibs/win32unix and otherlibs/win32graph
	# directories, but since they would normally only be built under
	# Windows, they only have the Makefile.nt files.  Just symlink
	# Makefile -> Makefile.nt for these cases.
	$(SED) -i "s,@libdir@,$(PREFIX)/$(TARGET)/lib,g" $(1)/otherlibs/win32unix/Makefile.nt
	$(SED) -i "s,@libdir@,$(PREFIX)/$(TARGET)/lib,g" $(1)/otherlibs/win32graph/Makefile.nt
	$(SED) -i "s,@libdir@,$(PREFIX)/$(TARGET)/lib,g" $(1)/otherlibs/bigarray/Makefile.nt
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
	$(MAKE) -C '$(1)/byterun' libcamlrun.a
	$(MAKE) -C '$(1)' ocaml ocamlc
	$(MAKE) -C '$(1)/stdlib'
	$(MAKE) -C '$(1)/tools' ocamlmklib
	# Build ocamlopt
	$(MAKE) -C '$(1)' opt
	# Now build otherlibs for ocamlopt
	cd '$(1)' && \
	  for i in $(OTHER_LIBS); do \
		$(MAKE) -C otherlibs/$$i clean; \
		$(MAKE) -C otherlibs/$$i all; \
		$(MAKE) -C otherlibs/$$i allopt; \
	done

	####### installation
	mkdir -p $(PREFIX)/$(TARGET)/lib/ocaml/threads
	mkdir -p $(PREFIX)/$(TARGET)/lib/ocaml/stublibs
	$(MAKE) -C '$(1)/byterun' \
		BINDIR=$(PREFIX)/$(TARGET)/bin \
		LIBDIR=$(PREFIX)/$(TARGET)/lib/ocaml \
		install
	$(MAKE) -C '$(1)/stdlib' \
		BINDIR=$(PREFIX)/$(TARGET)/bin \
		LIBDIR=$(PREFIX)/$(TARGET)/lib/ocaml \
		install
	for i in $(OTHER_LIBS); do \
		$(MAKE) -C $(1)/otherlibs/$$i \
			BINDIR=$(PREFIX)/$(TARGET)/bin \
			LIBDIR=$(PREFIX)/$(TARGET)/lib/ocaml \
			install; \
	done
	$(MAKE) -C '$(1)/tools' \
		BINDIR=$(PREFIX)/$(TARGET)/bin \
		LIBDIR=$(PREFIX)/$(TARGET)/lib/ocaml \
		install
	$(MAKE) -C '$(1)' \
		BINDIR=$(PREFIX)/$(TARGET)/bin \
		LIBDIR=$(PREFIX)/$(TARGET)/lib/ocaml \
		installopt
	cd $(1) && $(INSTALL) -m 0755 ocamlc $(PREFIX)/$(TARGET)/bin
	cd $(1) && cp \
	  toplevel/topstart.cmo \
	  typing/outcometree.cmi typing/outcometree.mli \
	  toplevel/toploop.cmi toplevel/toploop.mli \
	  toplevel/topdirs.cmi toplevel/topdirs.mli \
	  toplevel/topmain.cmi toplevel/topmain.mli \
	  $(PREFIX)/$(TARGET)/lib/ocaml
	# Rename all the binaries to target-binary
	for f in ocamlc ocamlcp ocamlrun ocamldep ocamlmklib ocamlmktop ocamlopt ocamlprof; do \
	  cp -f $(PREFIX)/$(TARGET)/bin/$$f $(PREFIX)/bin/$(TARGET)-$$f; \
	done

	# test
	cp '$(2).ml' '$(1)/test.ml'
	cd '$(1)' && '$(TARGET)-ocamlopt' test.ml
endef
