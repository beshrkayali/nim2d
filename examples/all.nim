import sdl2
import nim2d, nim2d/types, nim2d/graphics, nim2d/canvas, nim2d/image, nim2d/font

let f0 = newFont("font.ttf", 36)
let f1 = newFont("font.ttf", 72)
let f2 = newFont("font.ttf", 110)

var X: int16 = 50
var Y: int16 = 420

var an: int16 = 2
var anf: bool = true
var angle: cdouble = 0

let n2d = newNim2d(
  "Test all",
  0, 0,
  1024, 768,
)

let hello = stringToRunePtr "Hallå"
let world = stringToRunePtr "World!"

let nimlogo = n2d.newImage("Nim-logo.png")
discard nimlogo.setColorMod(250, 250, 250)

n2d.keydown = proc (nim2d: Nim2d, scancode: Scancode) =
  if scancode == Scancode.SDL_SCANCODE_A:
    X -= 5
  elif scancode == Scancode.SDL_SCANCODE_D:
    X += 5

n2d.keyup = proc (nim2d: Nim2d, scancode: Scancode) =
  if scancode == Scancode.SDL_SCANCODE_A:
    X -= 5
  elif scancode == Scancode.SDL_SCANCODE_D:
    X += 5

n2d.mousemove = proc(nim2d: Nim2d, x, y, dx, dy: int32) =
  X = int16 x
  Y = int16 y

n2d.mousepressed = proc(nim2d: Nim2d, x, y: int32, button, presses: uint8) =
  if button == 1:
    X = X - 100
    Y = Y - 100
  else:
    X = X + 100
    Y = Y + 100

n2d.mousereleased = proc(nim2d: Nim2d, x, y: int32, button, presses: uint8) =
  let x = X
  X = Y
  Y = x

let canv = n2d.newCanvas(250, 250)

n2d.load = proc (nim2d: Nim2d) =
  echo("Font ascent:")
  echo(f1.getAscent)

  echo("Font descent:")
  echo(f1.getDescent)

  echo("Font height:")
  echo(f1.getHeight)

  echo("Font has glyphs:")
  # todo: fix this
  # echo($f1.hasGlyphs(stringToRunePtr "ä"))

  echo("Size:")
  echo($f1.getSize(stringToRunePtr "Hello world!"))

  nim2d.setCanvas(canv)
  nim2d.setBackgroundColor(240, 240, 240)
  nim2d.setFont(f0)
  nim2d.print(stringToRunePtr "Canvas", 20, 20, angle = 0)

  discard nimlogo.setAlphaMod(255)

  nimlogo.draw(nim2d, 70, 100, angle=angle, flip=0, scale=0.1)

  discard nimlogo.setAlphaMod(10)
  nim2d.setCanvas()
  nim2d.setBackgroundColor(82, 93, 197)

n2d.update = proc (nim2d: Nim2d, dt: float) =
  angle = angle + (30 * dt)

  if angle > 359:
    angle = 0

  if anf:
    inc an
  else:
    dec an

  if an > 35 or an < 2:
    anf = not anf


n2d.quit = proc (nim2d: Nim2d) =
  echo("Quitting...")
    
n2d.draw = proc (nim2d: Nim2d) =
  nimlogo.draw(nim2d, 0, 0, angle=angle, flip=0)

  canv.draw(nim2d, 300, 10, 0, flip=0)
  discard canv.setAlphaMod(255)

  nim2d.setColor(0, 0, 0, 255)

  nim2d.setColor(220, 249, 80, 255)
  nim2d.setFont(f1)
  nim2d.print(hello, 340, 300, angle = angle * -1)

  nim2d.setColor(255, 109, 82, 255)
  nim2d.print(world, 475, 320, angle = angle)

  nim2d.setColor(255, 255, 255, 255)
  nim2d.arc(100, 100, 100, 90, int16 angle)

  var points = @[
    (cint 100, cint 100),
    (cint 150, cint 100),
    (cint 150, cint 150),
    (cint 100, cint 150),
    (cint 100, cint 100),
  ]

  nim2d.line(points)

  nim2d.circle(50, 250, 10, true)
  nim2d.circle(50, 250, 20)

  nim2d.rectangle(20, 320, 40, 20, true)
  nim2d.rectangle(70, 320, 40, 20, false)

  nim2d.rectangle(20, 350, 40, 20, true, 5)
  nim2d.rectangle(70, 350, 40, 20, false, 5)

  nim2d.pie(X, Y, 30, an, an * -1, true)

  nim2d.ellipse(100, 500, 50, 25, true)
  nim2d.ellipse(220, 500, 50, 25)

  nim2d.triangle(220, 10, 245, 60, 200, 60, true)

  nim2d.polygon(@[int16 100, int16 120, int16 140, int16 160, int16 180],
                @[int16 50, int16 10, int16 90, int16 40, int16 0],
                true)


n2d.play()
