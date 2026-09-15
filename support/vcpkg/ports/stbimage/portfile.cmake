# This port lives inside the stbimage repository and builds the enclosing checkout. When
# publishing stbimage to a registry, replace this with vcpkg_from_github(REPO sgct/stbimage
# REF <tag> SHA512 <hash>) so that the port is reproducible and content-addressed.
get_filename_component(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../../.." ABSOLUTE)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH share/stbimage)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
