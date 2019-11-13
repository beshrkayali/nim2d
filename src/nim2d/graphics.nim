import nim2d
import sdl2, sdl2/ttf

ttfInit()

type
  Font* = object
    fptr: FontPtr

proc newFont*(file: cstring, size: cint): Font =
  var fptr: FontPtr
  fptr = openFont(file, size)
  Font(fptr: fptr)

proc print*(text: string, nim2d: Nim2d, fnt: Font, x, y: cint): void =
  var col : Color = (uint8 0, uint8 0,  uint8 0,  uint8 255)
  let surfaceMessage: SurfacePtr = renderTextSolid(fnt.fptr, cstring text, col)
  let message = createTextureFromSurface(nim2d.renderer, surfaceMessage)

  let w: cint = 0
  let h: cint = 0

  discard sizeText(fnt.fptr, text, unsafeAddr w, unsafeAddr h)

  let rect: Rect = (x, y, w, h)

  copy(nim2d.renderer, message, nil, unsafeAddr rect)
