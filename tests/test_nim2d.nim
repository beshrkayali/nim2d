import sdl2
import nim2d, nim2d/types, nim2d/graphics


when isMainModule:
  block:
    let n2d = newNim2d(
      "Test all",
      0, 0,
      640, 480,
    )

    # Main callbacks
    n2d.load = proc (nim2d: Nim2d) =
      discard

    n2d.update = proc (nim2d: Nim2d, dt: float) =
      discard

    n2d.quit = proc (nim2d: Nim2d) =
      discard

    n2d.draw = proc (nim2d: Nim2d) =
      discard

    # Event callbacks
    n2d.keydown = proc (nim2d: Nim2d, scancode: Scancode) =
      discard

    n2d.keyup = proc (nim2d: Nim2d, scancode: Scancode) =
      discard

    n2d.mousemove = proc(nim2d: Nim2d, x, y, dx, dy: int32) =
      discard

    n2d.mousepressed = proc(nim2d: Nim2d, x, y: int32, button, presses: uint8) =
      discard

    n2d.mousereleased = proc(nim2d: Nim2d, x, y: int32, button, presses: uint8) =
      discard

    # n2d.play()
