# stbimage
A single compiled instantiation of [stb_image and stb_image_write](https://github.com/nothings/stb).

stb_image.h and stb_image_write.h are single-header libraries: exactly one
translation unit in a program is allowed to define `STB_IMAGE_IMPLEMENTATION`
/ `STB_IMAGE_WRITE_IMPLEMENTATION`, and every function they declare has
external linkage unless that translation unit also defines
`STB_IMAGE_STATIC` / `STB_IMAGE_WRITE_STATIC`. Both [Ghoul](https://github.com/OpenSpace/Ghoul)
and [SGCT](https://github.com/sgct/sgct) need stb_image/stb_image_write, and
both are linked into the same OpenSpace executable, so each independently
compiling its own implementation is a duplicate-symbol/ODR hazard. This
repository compiles each implementation exactly once instead, as two
separate objects (read and write; see "CMake targets" below) so a consumer
that already has a stb_image read implementation from elsewhere (e.g.
assimp) can link only the write half.

## CMake targets
This package exports three targets, all namespaced `unofficial::` because this
CMake package is authored by this repository, not by the upstream stb project:

- `unofficial::stbimage::stbimage` — an interface target with just the
  stb_image/stb_image_write declarations. Link this from any library that
  calls `stbi_*` functions but does not itself need to satisfy those symbols
  (e.g. Ghoul, SGCT); it never compiles anything.
- `unofficial::stbimage::stbimage-read-impl` — compiles just the stb_image
  (read) functions, such as `stbi_load`. Link this from an executable that
  needs those symbols resolved, unless something else already links a
  different stb_image read implementation (e.g. assimp vendors its own copy,
  and linking both would be a duplicate-symbol conflict).
- `unofficial::stbimage::stbimage-write-impl` — compiles just the
  stb_image_write (write) functions, such as `stbi_write_png`. Link this from
  an executable that needs those symbols resolved.

The read and write halves are split into separate targets/objects so that a
program which already gets stb_image's read functions from elsewhere (like
assimp) can link only the write half instead of pulling in a second,
conflicting copy of the read functions.

## Consuming stbimage
A vcpkg port lives in `support/vcpkg/ports/stbimage` and builds the enclosing
checkout. Ghoul, SGCT, and the OpenSpace superproject each maintain their own
overlay port (`support/vcpkg/ports/stbimage` in each of their own checkouts)
that instead fetches this repository directly from GitHub via
`vcpkg_from_github`, pinned to a commit here. None of them consume this
repository as a git submodule.

Either way:

```cmake
find_package(stbimage CONFIG REQUIRED)
target_link_libraries(mylib PRIVATE unofficial::stbimage::stbimage)
target_link_libraries(myexe PRIVATE unofficial::stbimage::stbimage-read-impl)
target_link_libraries(myexe PRIVATE unofficial::stbimage::stbimage-write-impl)
```
