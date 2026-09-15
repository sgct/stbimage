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
repository compiles the implementation exactly once into an `unofficial::stbimage::stbimage`
CMake target that both depend on instead. It is namespaced `unofficial::` because
this CMake package is authored by this repository, not by the upstream stb project.

## Consuming stbimage
A vcpkg port lives in `support/vcpkg/ports/stbimage` and builds the enclosing
checkout. Ghoul and OpenSpace consume it as a git submodule at `ext/stbimage`,
registering `ext/stbimage/support/vcpkg/ports` as an overlay-port path:

```json
{
  "overlay-ports": [ "ext/stbimage/support/vcpkg/ports" ]
}
```

SGCT instead fetches this repository directly from its own overlay port
(`support/vcpkg/ports/stbimage` in the SGCT checkout), via `vcpkg_from_github`
pinned to a commit here, so that SGCT keeps building from vcpkg alone with no
submodule to initialize.

Either way, link against it the same way:

```cmake
find_package(stbimage CONFIG REQUIRED)
target_link_libraries(main PRIVATE unofficial::stbimage::stbimage)
```
