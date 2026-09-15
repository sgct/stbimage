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
repository compiles the implementation exactly once instead.

## CMake targets
This package exports two targets, both namespaced `unofficial::` because this
CMake package is authored by this repository, not by the upstream stb project:

- `unofficial::stbimage::headers` — an interface target with just the
  stb_image/stb_image_write declarations. Link this from any library that
  calls `stbi_*` functions but does not itself need to satisfy those symbols
  (e.g. Ghoul, SGCT); it never compiles anything.
- `unofficial::stbimage::stbimage` — the compiled implementation. Link this
  from whichever executable actually produces the final link (e.g. the
  OpenSpace application, SGCT's `calibrator`), since that is the only place
  the symbols need to be resolved. It publicly links
  `unofficial::stbimage::headers`, so linking it also gives you the
  declarations.

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
target_link_libraries(mylib PRIVATE unofficial::stbimage::headers)
target_link_libraries(myexe PRIVATE unofficial::stbimage::stbimage)
```
