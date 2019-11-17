import sdl2
import nim2d, nim2d/graphics

let f1 = newFont("font.ttf", 72)
let f2 = newFont("font.ttf", 110)

var x: int16 = 50
let y: int16 = 420

var an: int16 = 2
var anf: bool = true


let n2d = newNim2d(
  "Test all",
  0, 0,
  1024, 768,
)

n2d.keydown = proc (nim2d: Nim2d, scancode: Scancode) =
  if scancode == Scancode.SDL_SCANCODE_A:
    x -= 5
  elif scancode == Scancode.SDL_SCANCODE_D:
    x += 5

n2d.keyup = proc (nim2d: Nim2d, scancode: Scancode) =
  if scancode == Scancode.SDL_SCANCODE_A:
    x -= 5
  elif scancode == Scancode.SDL_SCANCODE_D:
    x += 5

n2d.load = proc (nim2d: Nim2d) =
  nim2d.setBackgroundColor(82, 93, 197)

n2d.update = proc (nim2d: Nim2d) =
  if anf:
    inc an
  else:
    dec an

  if an > 35 or an < 2:
    anf = not anf

n2d.draw = proc (nim2d: Nim2d) =
  nim2d.setColor(220, 249, 80, 255)
  nim2d.print("NIM", 400, 300, f1)

  nim2d.setColor(255, 109, 82, 255)
  nim2d.print("2D!", 485, 280, f2)

  nim2d.setColor(255, 255, 255, 255)
  nim2d.arc(100, 100, 100, 90, 0)
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

  nim2d.pie(x, y, 30, an, an * -1, true)

  nim2d.ellipse(100, 500, 50, 25, true)
  nim2d.ellipse(220, 500, 50, 25)

  nim2d.triangle(220, 10, 245, 60, 200, 60, true)

  nim2d.polygon(@[int16 100, int16 120, int16 140, int16 160, int16 180],
                @[int16 50, int16 10, int16 90, int16 40, int16 0],
                true)

  nim2d.string("Hi! This demo tests all of nim2d's api", 400, 400)


n2d.play()
