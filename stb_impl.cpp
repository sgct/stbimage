// The single translation unit that instantiates stb_image and stb_image_write. See this
// repository's README for why this needs to be its own shared library rather than something
// each consumer (Ghoul, SGCT) compiles for itself.

#define STBI_FAILURE_USERMSG
#define STBI_NO_SIMD
#define STB_IMAGE_IMPLEMENTATION
#include <stb_image.h>

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include <stb_image_write.h>
