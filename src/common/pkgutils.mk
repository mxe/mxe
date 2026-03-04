# ----------------------------------------------------------------------
# GENERATE_PC
# ----------------------------------------------------------------------
# Generates a pkg-config (.pc) file for a library that does not provide one.
# This allows downstream builds and tools to discover the library and its
# compiler/linker flags via pkg-config.
#
# Usage:
# $(call GENERATE_PC, \
#     <prefix>,           # Installation prefix (e.g., $(PREFIX)/$(TARGET))
#     <name>,             # Package name (e.g., libraw)
#     <description>,      # Package description
#     <version>,          # Package version
#     <requires>,         # Public Dependencies (space-separated)
#     <requires_private>, # Private dependencies (optional)
#     <libs>,             # Public linker flags (-L${libdir} already included)
#     <libs_private>,     # Private linker flags (optional)
#     <cflags>,           # Public Compiler flags (I${includedir} already included)
#     <cflags_private>    # Private compiler flags (optional)
# )
#
# Example:
# $(call GENERATE_PC, \
#     $(PREFIX)/$(TARGET), \
#     libraw, \
#     Raw image decoder library, \
#     $($(PKG)_VERSION), \
#     lcms2 zlib, \
#     jasper jpeg, \
#     -lraw_r -lstdc++ -fopenmp some/path, \
#     -ljasper -ljpeg, \
#     libraw lnextlib some/path, \
#     -DLIBRAW_NODLL -DANOTHER_CFLAG \
# )
#
# Notes:
#   - Any field can be left empty; pkg-config will ignore it.
#   - Template variables in library.pc.in are replaced with the provided values.
#   - Public linker flags (Libs) already include -L${libdir}. Any additional paths containing slashes are added explicitly as -L/full/path.
#   - Public compiler flags (Cflags) already include -I${includedir}. Any additional entries containing slashes are added explicitly as -I/full/path.
# ----------------------------------------------------------------------
include src/common/library.pc.in

define GENERATE_PC
$(INSTALL) -d $(strip $1)/lib/pkgconfig
sed \
    -e 's|@PREFIX@|$(strip $1)|g' \
    -e 's|@NAME@|$(strip $2)|g' \
    -e 's|@DESCRIPTION@|$(strip $3)|g' \
    -e 's|@VERSION@|$(strip $4)|g' \
    -e 's|@REQUIRES@|$(strip $5)|g' \
    -e 's|@REQUIRES_PRIVATE@|$(strip $6)|g' \
    -e 's|@LIBS@|$(strip $(foreach f,$7,$(if $(findstring /,$f),-L$(f),$f)))|g' \
    -e 's|@LIBS_PRIVATE@|$(strip $8)|g' \
    -e 's|@CFLAGS@|$(strip $(foreach f,$(9),$(if $(findstring /,$f),-I$(f),-I$${includedir}/$(f))))|g' \
    -e 's|@CFLAGS_PRIVATE@|$(strip ${10})|g' \
    src/common/library.pc.in > $(strip $1)/lib/pkgconfig/$(strip $2).pc
endef
