import sdl2, sdl2/gfx

discard sdl2.init(INIT_EVERYTHING)

type
  Nim2d* = ref object
    window: WindowPtr
    renderer*: RendererPtr
    background*: tuple[r, g, b, a: uint8]
    color*: tuple[r, g, b, a: uint8]
    fpsman: FpsManager
    running: bool
    load: proc(nim2d: Nim2d)
    draw: proc(nim2d: Nim2d)
    update: proc(nim2d: Nim2d)

proc `load=`*(n2d: Nim2d, load: proc (nim2d: NIm2d)) {.inline.} =
  n2d.load = load

proc `update=`*(n2d: Nim2d, update: proc (nim2d: NIm2d)) {.inline.} =
  n2d.update = update

proc `draw=`*(n2d: Nim2d, draw: proc (nim2d: NIm2d)) {.inline.} =
  n2d.draw = draw

proc newNim2d*(title: string, x, y, width, height: cint, background: tuple[r, g, b, a: uint8]): Nim2d =
  let window: WindowPtr = createWindow(
    title,
    x,
    y,
    width,
    height,
    SDL_WINDOW_SHOWN
  )

  let renderer: RendererPtr = createRenderer(
    window,
    -1,
    Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture
  )

  let color = (uint8 0, uint8 0, uint8 0, uint8 255)

  Nim2d(
    background: background,
    color: color,
    window: window,
    renderer: renderer,
    fpsman: FpsManager(),
    running: true,
  )

proc newNim2d*(title: string, x, y, width, height: cint): Nim2d =
  newNim2d(title, x, y, width, height, (r: uint8 89, g: uint8 157, b: uint8 220, a: uint8 255))

proc play*(nim2d: Nim2d): void =
  nim2d.fpsman.init
  var evt = sdl2.defaultEvent

  nim2d.load(nim2d)

  while nim2d.running:
    while pollEvent(evt):
      if evt.kind == QuitEvent:
        nim2d.running = false
        break

    let dt = nim2d.fpsman.getFramerate() / 1000

    nim2d.renderer.setDrawColor(
      nim2d.background.r,
      nim2d.background.g,
      nim2d.background.b,
      nim2d.background.a
    )

    nim2d.renderer.clear

    nim2d.draw(nim2d)

    nim2d.renderer.present
    nim2d.fpsman.delay
    nim2d.update(nim2d)

  destroy nim2d.renderer
  destroy nim2d.window
