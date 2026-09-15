// Write-only half of the split stb_image / stb_image_write implementation; linking
// only this avoids duplicate stb_image *read* symbols against libraries that vendor
// their own stb_image copy (e.g. assimp). See the README for details.

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include <stb_image_write.h>
