// Read-only half of the split stb_image / stb_image_write implementation; see
// stb_impl_write.cpp for the write half and the README for why these are split.

#define STBI_FAILURE_USERMSG
#define STBI_NO_SIMD
#define STB_IMAGE_IMPLEMENTATION
#include <stb_image.h>
