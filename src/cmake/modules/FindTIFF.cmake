if(TARGET TIFF::TIFF)
    set(TIFF_FOUND TRUE)
    return()
endif()

find_package(PkgConfig QUIET)

if(PkgConfig_FOUND)
    pkg_check_modules(TIFF IMPORTED_TARGET libtiff-4)

    if(TARGET PkgConfig::TIFF)
        add_library(TIFF::TIFF INTERFACE IMPORTED)
        target_link_libraries(TIFF::TIFF INTERFACE PkgConfig::TIFF)
        set(TIFF_FOUND TRUE)
    endif()
endif()

if(NOT TARGET TIFF::TIFF)
    find_library(TIFF_LIBRARY NAMES tiff-4)
    find_path(TIFF_INCLUDE_DIR tiff.h)

    if(TIFF_LIBRARY AND TIFF_INCLUDE_DIR)
        add_library(TIFF::TIFF UNKNOWN IMPORTED)
        set_target_properties(TIFF::TIFF PROPERTIES
            IMPORTED_LOCATION ${TIFF_LIBRARY}
            INTERFACE_INCLUDE_DIRECTORIES ${TIFF_INCLUDE_DIR}
        )
    endif()

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(TIFF REQUIRED_VARS
        TIFF_LIBRARY
        TIFF_INCLUDE_DIR
    )
endif()
