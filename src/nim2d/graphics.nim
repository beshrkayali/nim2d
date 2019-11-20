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

proc hasGlyphs*(font: Font, text: uint16): bool =
  bool glyphIsProvided(font.address, text)

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

type
  Drawable* = ref object of RootObj


type
  Image* = ref object of Drawable
    texture: TexturePtr
    width: cint
    height: cint

# Images
# ------
proc newImage*(nim2d: Nim2d, file: string): Image =
  let surfaceImage: SurfacePtr = image.load(cstring file)

  let texture = createTextureFromSurface(nim2d.renderer, surfaceImage)

  let img = Image(
    texture: texture
  )

  queryTexture(texture, nil, nil, unsafeAddr img.width, unsafeAddr img.height)

  return img


proc draw*(image: Image, nim2d: Nim2d, x, y: cint, angle: cdouble = 0, center: ptr Point = nil, flip: cint = 0) =
  let rect: Rect = (x, y, image.width, image.height)
  copyEx(nim2d.renderer, image.texture, nil, unsafeAddr rect, angle, center, flip)


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
