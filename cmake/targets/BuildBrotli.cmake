find_package(PkgConfig QUIET)

if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_BROTLI_COMMON QUIET libbrotlicommon)
  pkg_check_modules(PC_BROTLI_ENC QUIET libbrotlienc)
  pkg_check_modules(PC_BROTLI_DEC QUIET libbrotlidec)
endif()

find_library(BROTLI_COMMON_LIBRARY
  NAMES brotlicommon
  HINTS ${PC_BROTLI_COMMON_LIBDIR} ${PC_BROTLI_COMMON_LIBRARY_DIRS}
)

find_library(BROTLI_ENC_LIBRARY
  NAMES brotlienc
  HINTS ${PC_BROTLI_ENC_LIBDIR} ${PC_BROTLI_ENC_LIBRARY_DIRS}
)

find_library(BROTLI_DEC_LIBRARY
  NAMES brotlidec
  HINTS ${PC_BROTLI_DEC_LIBDIR} ${PC_BROTLI_DEC_LIBRARY_DIRS}
)

find_path(BROTLI_INCLUDE_DIR
  NAMES brotli/encode.h
  HINTS ${PC_BROTLI_ENC_INCLUDEDIR} ${PC_BROTLI_ENC_INCLUDE_DIRS}
)

if(PC_BROTLI_COMMON_VERSION)
  set(BROTLI_VERSION ${PC_BROTLI_COMMON_VERSION})
elseif(PC_BROTLI_ENC_VERSION)
  set(BROTLI_VERSION ${PC_BROTLI_ENC_VERSION})
elseif(PC_BROTLI_DEC_VERSION)
  set(BROTLI_VERSION ${PC_BROTLI_DEC_VERSION})
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Brotli
  REQUIRED_VARS
    BROTLI_COMMON_LIBRARY
    BROTLI_ENC_LIBRARY
    BROTLI_DEC_LIBRARY
    BROTLI_INCLUDE_DIR
  VERSION_VAR BROTLI_VERSION
)

if(BROTLI_FOUND)
  set(BROTLI_LIBRARIES ${BROTLI_COMMON_LIBRARY} ${BROTLI_ENC_LIBRARY} ${BROTLI_DEC_LIBRARY})
  set(BROTLI_INCLUDE_DIRS ${BROTLI_INCLUDE_DIR})

  # Create imported target for common library
  if(NOT TARGET Brotli::BrotliCommon)
    add_library(Brotli::BrotliCommon UNKNOWN IMPORTED)
    set_target_properties(Brotli::BrotliCommon PROPERTIES
      IMPORTED_LOCATION "${BROTLI_COMMON_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${BROTLI_INCLUDE_DIR}"
    )
  endif()

  # Create imported target for encoder library
  if(NOT TARGET Brotli::BrotliEnc)
    add_library(Brotli::BrotliEnc UNKNOWN IMPORTED)
    set_target_properties(Brotli::BrotliEnc PROPERTIES
      IMPORTED_LOCATION "${BROTLI_ENC_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${BROTLI_INCLUDE_DIR}"
      INTERFACE_LINK_LIBRARIES "Brotli::BrotliCommon"
    )
  endif()

  # Create imported target for decoder library
  if(NOT TARGET Brotli::BrotliDec)
    add_library(Brotli::BrotliDec UNKNOWN IMPORTED)
    set_target_properties(Brotli::BrotliDec PROPERTIES
      IMPORTED_LOCATION "${BROTLI_DEC_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${BROTLI_INCLUDE_DIR}"
      INTERFACE_LINK_LIBRARIES "Brotli::BrotliCommon"
    )
  endif()

  # Create combined target
  if(NOT TARGET Brotli::Brotli)
    add_library(Brotli::Brotli INTERFACE IMPORTED)
    set_target_properties(Brotli::Brotli PROPERTIES
      INTERFACE_LINK_LIBRARIES "Brotli::BrotliEnc;Brotli::BrotliDec;Brotli::BrotliCommon"
      INTERFACE_INCLUDE_DIRECTORIES "${BROTLI_INCLUDE_DIR}"
    )
  endif()
endif()

add_library(brotli ALIAS Brotli::Brotli)

mark_as_advanced(
  BROTLI_INCLUDE_DIR
  BROTLI_COMMON_LIBRARY
  BROTLI_ENC_LIBRARY
  BROTLI_DEC_LIBRARY
)
