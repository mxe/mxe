# GENERATE_PC
# Generates a .pc (pkg-config) file for a package that doesn't provide one.
# Useful for making the package discoverable by downstream builds and other
# applications that rely on pkg-config to find libraries and headers.

# Example usage:
# $(call GENERATE_PC, \
#     $(PREFIX)/$(TARGET), \
#     opensubdiv, \
#     Pixar OpenSubdiv library for subdivision surface evaluation, \
#     $($(PKG)_VERSION), \
#     tbb zlib clew, \
#     -losdCPU -ltbb12 -lz -lclew, \
#     "" \
# )

define GENERATE_PC
$(INSTALL) -d $1/lib/pkgconfig
(echo "prefix=$(strip $1)"; \
echo "exec_prefix=\$${prefix}"; \
echo "libdir=\$${exec_prefix}/lib"; \
echo "includedir=\$${prefix}/include"; \
echo ""; \
echo "Name: $(strip $2)"; \
echo "Description: $(strip $3)"; \
echo "Version: $(strip $4)"; \
echo ""; \
echo "Cflags: -I\$${includedir}"; \
echo "Libs: -L\$${libdir}"; \
echo "Requires: $(strip $5)"; \
echo "Libs.private: $(strip $6)"; \
echo "Requires.private: $(strip $7)";) \
> $1/lib/pkgconfig/$(strip $2).pc
endef
