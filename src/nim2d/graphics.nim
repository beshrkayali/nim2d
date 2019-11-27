import unicode
import nim2d/types
import sdl2, sdl2/ttf, sdl2/gfx, sdl2/image

ttfInit()

# TTF
# ---

func newFont*(filename: cstring, size: cint): Font =
  let fptr: FontPtr = openFont(filename, size)
  Font(address: fptr, filename: filename, size: size)

proc getAscent*(font: Font): int =
  fontAscent(font.address)

proc getDescent*(font: Font): int =
  fontDescent(font.address)

proc getHeight*(font: Font): int =
  fontHeight(font.address)

proc getLineHeight*(font: Font) =
  discard

proc getSize*(font: Font, text: ptr uint16): (cint, cint) =
  let w: cint = 0
  let h: cint = 0
  discard sizeUnicode(font.address, text, unsafeAddr w, unsafeAddr h)
  return (w, h)

proc getWrap*(font: Font) =
  discard

proc hasGlyphs*(font: Font, text: ptr uint16): bool =
  bool glyphIsProvided(font.address, text[])

proc stringToRunePtr*(text: string): ptr uint16 = 
  var result = newSeq[uint16]()
  for r in text.runes:
    result.add(uint16 r)

  return unsafeAddr result[0]

proc print*(nim2d: Nim2d, text: ptr uint16, x, y: cint, w: cint = 0, h: cint = 0, angle: cdouble = 0, center: ptr Point = nil, flip: cint = 0): void =
  if nim2d.font.address == nil:
    echo("No font set")
    return

  let surfaceMessage: SurfacePtr = renderUnicodeSolid(
    nim2d.font.address,
    text,
    nim2d.color
  )

  let message = createTextureFromSurface(nim2d.renderer, surfaceMessage)

  if w == 0 and h == 0:
    discard sizeUnicode(nim2d.font.address, text, unsafeAddr w, unsafeAddr h)

  let rect: Rect = (x, y, w, h)
  copyEx(nim2d.renderer, message, nil, unsafeAddr rect, angle, center, flip)

# proc setFallback*(font: Font) =
#   discard

# proc setFilter*(font: Font) =
#   discard

# proc setLineHeight*(font: Font) =
#   discard
    

proc loadTextureData(renderer: RendererPtr, filename: string): TexturePtr =
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


# Images
# ------
proc newImage*(nim2d: Nim2d, filename: string): Image =
  let texture = loadTextureData(nim2d.renderer, filename)
  
  let img = Image(
    data: texture
  )

  queryTexture(texture, nil, nil, unsafeAddr img.width, unsafeAddr img.height)

  return img


proc draw*(image: Image, nim2d: Nim2d, x, y: cint, angle: cdouble = 0, center: ptr Point = nil, flip: cint = 0, scale: float = 1.0) =
  let rect: Rect = (x, y, cint(float(image.width) * scale), cint(float(image.height) * scale))
  copyEx(nim2d.renderer, image.data, nil, unsafeAddr rect, angle, center, flip)

proc getDimensions*(image: Image): (cint, cint) =
  return (image.width, image.height)

proc getWidth*(image: Image): cint =
  return image.width

proc getHeight*(image: Image): cint =
  return image.height


# Canvas
# ------
proc newCanvas*(nim2d: Nim2d, width, height: cint): Canvas =
  let textureData: TexturePtr = createTexture(
    nim2d.renderer,
    SDL_PIXELFORMAT_RGBA8888,
    SDL_TEXTUREACCESS_TARGET,
    width,
    height,
  );
  echo((width, height))

  Canvas(
    data: textureData
  )


proc newCanvas*(nim2d: Nim2d): Canvas =
  newCanvas(nim2d, nim2d.width, nim2d.height)

  
# Drawing
# -------
proc line*(nim2d: Nim2d, points: seq[Point]) =
  setDrawColor(nim2d.renderer, nim2d.color.r, nim2d.color.g, nim2d.color.b)
  drawLines(nim2d.renderer, unsafeAddr points[0], cint len points)

proc circle*(nim2d: Nim2d, x, y, rad: int16, filled: bool = false) =
  if filled:
    filledCircleRGBA(nim2d.renderer, x, y, rad, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)
  else:
    aacircleRGBA(nim2d.renderer, x, y, rad, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)

proc rectangle*(nim2d: Nim2d, x1, y1, width, height: int16, filled: bool = false, roundness: int16 = 0) =
  if filled:
    if roundness > 0:
      roundedBoxRGBA(nim2d.renderer, x1, y1, x1 + width, y1  + height, roundness, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)
    else:
      boxRGBA(nim2d.renderer, x1, y1, x1 + width, y1  + height, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)
  else:
    if roundness > 0:
      roundedRectangleRGBA(nim2d.renderer, x1, y1, x1 + width, y1  + height, roundness, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)
    else:
      rectangleRGBA(nim2d.renderer, x1, y1, x1 + width, y1 + height, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)

proc arc*(nim2d: Nim2d, x, y, rad, angle1, angle2: int16) =
  arcRGBA(nim2d.renderer, x, y, rad, angle1, angle2, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)

proc pie*(nim2d: Nim2d, x, y, rad, angle1, angle2: int16, filled: bool = false) =
  if filled:
    filledPieRGBA(nim2d.renderer, x, y, rad, angle1, angle2, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)
  else:
    pieRGBA(nim2d.renderer, x, y, rad, angle1, angle2, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)

proc ellipse*(nim2d: Nim2d, x, y, width, height: int16, filled: bool = false) =
  if filled:
    filledEllipseRGBA(nim2d.renderer, x, y, width, height, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)
  else:
    aaellipseRGBA(nim2d.renderer, x, y, width, height, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)

proc triangle*(nim2d: Nim2d, x1, y1, x2, y2, x3, y3: int16, filled: bool = false) =
  if filled:
    filledTrigonRGBA(nim2d.renderer, x1, y1, x2, y2, x3, y3, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)
  else:
    aaTrigonRGBA(nim2d.renderer, x1, y1, x2, y2, x3, y3, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)

proc polygon*(nim2d: Nim2d, x: seq[int16], y: seq[int16], filled: bool = false) =
  if len(x) != len(y):
    raise newException(OSError, "Length of x and y array must match")

  if len(x) < 3:
    raise newException(OSError, "Length of x and y array must be at least 3")

  if filled:
    filledPolygonRGBA(nim2d.renderer, unsafeAddr x[0], unsafeAddr y[0], cint len x, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)
  else:
    aaPolygonRGBA(nim2d.renderer, unsafeAddr x[0], unsafeAddr y[0], cint len x, nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)
