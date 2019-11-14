import nim2d
import sdl2, sdl2/ttf, sdl2/gfx

ttfInit()

type
  Font* = object
    fptr: FontPtr

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

proc string*(nim2d: Nim2d, text: cstring, x, y: int16) =
  stringRGBA(nim2d.renderer, x, y, text,  nim2d.color.r, nim2d.color.g, nim2d.color.b, nim2d.color.a)


# Color stuff
# -----------
func setColor*(nim2d: Nim2d, r, g, b, a: uint8) =
  nim2d.color = (r, g, b, a)
  
func setBackgroundColor*(nim2d: Nim2d, r, g, b: uint8) =
  nim2d.background = (r, g, b, uint8 255)


# TTF
# ----
func newFont*(file: cstring, size: cint): Font =
  var fptr: FontPtr
  fptr = openFont(file, size)
  Font(fptr: fptr)

func print*(nim2d: Nim2d, text: string, x, y: cint, fnt: Font): void =
  let surfaceMessage: SurfacePtr = renderTextSolid(
    fnt.fptr,
    cstring text,
    nim2d.color
  )

  let message = createTextureFromSurface(nim2d.renderer, surfaceMessage)

  let w: cint = 0
  let h: cint = 0
  discard sizeText(fnt.fptr, text, unsafeAddr w, unsafeAddr h)

  let rect: Rect = (x, y, w, h)

  copy(nim2d.renderer, message, nil, unsafeAddr rect)
