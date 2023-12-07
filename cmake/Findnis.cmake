
include_guard(GLOBAL)

include(CheckCSourceCompiles)
include(CMakePushCheckState)
if(TARGET nis::nis)
  return()
endif()

cmake_push_check_state(RESET)
set(CMAKE_REQUIRED_QUIET ON)

set(test_src "
#include <rpc/rpc.h>
#include <rpcsvc/ypclnt.h>
#include <rpcsvc/yp_prot.h>
#include <stdio.h>
int main(void){ printf(\"error: %s\", yperr_string(0)); return 0; }
")

set(NIS_SYSLIBS OFF)
set(NIS_PKG OFF)

check_c_source_compiles("${test_src}" NIS_IN_LIBC)
if(NIS_IN_LIBC)
  set(NIS_MSG "System libc")
  set(NIS_FOUND ${NIS_IN_LIBC})
endif()

if(NOT NIS_IN_LIBC AND (CMAKE_SYSTEM_NAME STREQUAL "Linux"))
find_package(PkgConfig QUIET)
  if(PKG_CONFIG_FOUND)
    pkg_check_modules(LIBNSL REQUIRED QUIET IMPORTED_TARGET libnsl)
    if(TARGET PkgConfig::LIBNSL)
      set(CMAKE_REQUIRED_LIBRARIES PkgConfig::LIBNSL)
      check_c_source_compiles("${test_src}" NIS_IN_PKG)
      if(NIS_IN_PKG)
        set(NIS_MSG "pkg-config libnsl")
        set(NIS_FOUND ${LIBNSL_FOUND})
        set(NIS_PKG ON)
      endif()
    endif()
  endif()
endif()

if(NOT NIS_PKG AND NOT NIS_IN_LIBC)
  if(CMAKE_SYSTEM_NAME STREQUAL "SunOS")
    set(NIS_SYSTEM_LIBS "nsl")
  endif()

  set(CMAKE_REQUIRED_LIBRARIES ${NIS_SYSTEM_LIBS})
  check_c_source_compiles("${test_src}" NIS_IN_SYSLIBS)
  if(NIS_IN_SYSLIBS)
    set(NIS_MSG "System ${NIS_SYSTEM_LIBS}")
    set(NIS_FOUND ${NIS_IN_SYSLIBS})
    set(NIS_SYS ON)
  endif()
endif()

if(NIS_FOUND)
  add_library(nis::nis INTERFACE IMPORTED)
  if(NIS_PKG)
    target_link_libraries(nis::nis INTERFACE PkgConfig::LIBNSL)
  endif()
  if(NIS_SYS)
    target_link_libraries(nis::nis INTERFACE ${NIS_SYSTEM_LIBS})
  endif()
endif()

cmake_pop_check_state()

find_package_handle_standard_args(nis FOUND_VAR nis_FOUND REQUIRED_VARS NIS_MSG)
