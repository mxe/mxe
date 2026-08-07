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
  $(INSTALL) -d '$(strip $1)/lib/pkgconfig'; \
  $(INSTALL) -d '$(strip $1)/share/pkgconfig'; \
  pc_dir_lib="$(strip $1)/lib/pkgconfig"; \
  pc_dir_share="$(strip $1)/share/pkgconfig"; \
  pc_name="$(strip $2).pc"; \
  pc_file_lib="$$pc_dir_lib/$$pc_name"; \
  pc_file_share="$$pc_dir_share/$$pc_name"; \
  \
  existing_file=""; \
  if [ -f "$$pc_file_lib" ]; then existing_file="$$pc_file_lib"; \
  elif [ -f "$$pc_file_share" ]; then existing_file="$$pc_file_share"; \
  fi; \
  \
  if [ -n "$$existing_file" ]; then \
      if grep -q "MXE" "$$existing_file"; then \
          echo "Overwriting MXE-generated $$existing_file"; \
      else \
          echo "Skipping upstream .pc file: $$existing_file (remove it if you want MXE to generate its own)"; \
          exit 0; \
      fi; \
  else \
      echo "Generating new .pc file"; \
  fi; \
  \
  $(SED) \
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
      src/common/library.pc.in > "$$pc_file_lib"
endef
