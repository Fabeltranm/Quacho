INCLUDE(FindPkgConfig)
PKG_CHECK_MODULES(PC_QUACHO Quacho)

FIND_PATH(
    QUACHO_INCLUDE_DIRS
    NAMES Quacho/api.h
    HINTS $ENV{QUACHO_DIR}/include
        ${PC_QUACHO_INCLUDEDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/include
          /usr/local/include
          /usr/include
)

FIND_LIBRARY(
    QUACHO_LIBRARIES
    NAMES gnuradio-Quacho
    HINTS $ENV{QUACHO_DIR}/lib
        ${PC_QUACHO_LIBDIR}
    PATHS ${CMAKE_INSTALL_PREFIX}/lib
          ${CMAKE_INSTALL_PREFIX}/lib64
          /usr/local/lib
          /usr/local/lib64
          /usr/lib
          /usr/lib64
)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(QUACHO DEFAULT_MSG QUACHO_LIBRARIES QUACHO_INCLUDE_DIRS)
MARK_AS_ADVANCED(QUACHO_LIBRARIES QUACHO_INCLUDE_DIRS)

