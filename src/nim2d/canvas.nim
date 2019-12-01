import sdl2
import nim2d/types


proc newCanvas*(nim2d: Nim2d, width, height: cint): Canvas =
  let textureData: TexturePtr = createTexture(
    nim2d.renderer,
    SDL_PIXELFORMAT_RGBA8888,
    SDL_TEXTUREACCESS_TARGET,
    width,
    height,
  )

  Canvas(
    data: textureData,
    width: width,
    height: height
  )


proc newCanvas*(nim2d: Nim2d): Canvas =
  newCanvas(nim2d, nim2d.width, nim2d.height)

proc getImageData*(canvas: Canvas): ImageData =
  discard
