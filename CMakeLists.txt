cmake_minimum_required(VERSION 3.20)
project(stbimage LANGUAGES CXX)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

find_package(Stb REQUIRED)

add_library(stbimage INTERFACE)
add_library(unofficial::stbimage::stbimage ALIAS stbimage)

add_library(stbimage-read-impl STATIC stb_impl_read.cpp)
target_include_directories(stbimage-read-impl SYSTEM PRIVATE ${Stb_INCLUDE_DIR})
target_link_libraries(stbimage-read-impl PUBLIC stbimage)

add_library(stbimage-write-impl STATIC stb_impl_write.cpp)
target_include_directories(stbimage-write-impl SYSTEM PRIVATE ${Stb_INCLUDE_DIR})
target_link_libraries(stbimage-write-impl PUBLIC stbimage)

install(
  TARGETS stbimage-read-impl stbimage-write-impl stbimage
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
