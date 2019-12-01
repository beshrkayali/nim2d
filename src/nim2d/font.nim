import unicode
import sdl2, sdl2/ttf
import nim2d/types


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

