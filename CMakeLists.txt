cmake_minimum_required(VERSION 3.20)
project(stbimage LANGUAGES CXX)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

find_package(Stb REQUIRED)

add_library(stbimage-headers INTERFACE)
add_library(unofficial::stbimage::headers ALIAS stbimage-headers)

add_library(stbimage STATIC stb_impl.cpp)
add_library(unofficial::stbimage::stbimage ALIAS stbimage)

target_include_directories(stbimage SYSTEM PRIVATE ${Stb_INCLUDE_DIR})
target_link_libraries(stbimage PUBLIC stbimage-headers)

install(
  TARGETS stbimage stbimage-headers
  EXPORT stbimageTargets
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(
  EXPORT stbimageTargets
  FILE stbimage-targets.cmake
  NAMESPACE unofficial::stbimage::
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
