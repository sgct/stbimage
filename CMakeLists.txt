cmake_minimum_required(VERSION 3.20)
project(stbimage LANGUAGES CXX)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

find_package(Stb REQUIRED)

add_library(stbimage STATIC stb_impl.cpp)
add_library(stbimage::stbimage ALIAS stbimage)

target_include_directories(stbimage SYSTEM PRIVATE ${Stb_INCLUDE_DIR})

install(
  TARGETS stbimage
  EXPORT stbimageTargets
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(
  EXPORT stbimageTargets
  FILE stbimage-targets.cmake
  NAMESPACE stbimage::
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/stbimage
)

configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/stbimageConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/stbimageConfig.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/stbimage
)
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/stbimageConfig.cmake
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/stbimage
)
