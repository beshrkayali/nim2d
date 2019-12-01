import sdl2, sdl2/image
import nim2d/types


# Texture

proc loadTextureData*(renderer: RendererPtr, filename: string): TexturePtr =
  let surfaceImage: SurfacePtr = image.load(cstring filename)
  createTextureFromSurface(renderer, surfaceImage)

proc newTexture*(renderer: RendererPtr, filename: string): Texture =
  let texture = loadTextureData(renderer, filename)
  Texture(data: texture)

proc destroy*(texture: Texture) =
  destroyTexture(texture.data)

proc setColorMod*(texture: Texture, r, g, b: uint8): bool =
  setTextureColorMod(texture.data, r, g, b) == SdlSuccess

proc getColorMod*(texture: Texture): (uint8, uint8, uint8) =
  var r, g, b: uint8
  discard getTextureColorMod(texture.data, r, g, b)
  return (r, g, b)

proc setAlphaMod*(texture: Texture, alpha: uint8): bool =
  setTextureAlphaMod(texture.data, alpha) == SdlSuccess

proc getAlphaMod*(texture: Texture): uint =
  var alpha: uint8
  discard getTextureAlphaMod(texture.data, alpha)
  return alpha


# Image

proc newImage*(nim2d: Nim2d, filename: string): Image =
  let texture = loadTextureData(nim2d.renderer, filename)

  let img = Image(
    data: texture
  )

  queryTexture(texture, nil, nil, unsafeAddr img.width, unsafeAddr img.height)

  return img


proc draw*(image: Image, nim2d: Nim2d, x, y: cint, angle: cdouble = 0,
    center: ptr Point = nil, flip: cint = 0, scale: float = 1.0) =
  let rect: Rect = (x, y, cint(float(image.width) * scale), cint(float(
      image.height) * scale))
  copyEx(nim2d.renderer, image.data, nil, unsafeAddr rect, angle, center, flip)

proc getDimensions*(image: Image): (cint, cint) =
  return (image.width, image.height)

proc getWidth*(image: Image): cint =
  return image.width

proc getHeight*(image: Image): cint =
  return image.height
