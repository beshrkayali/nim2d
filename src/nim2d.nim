import nim2d/types
import sdl2, sdl2/gfx

discard sdl2.init(INIT_EVERYTHING)

  
# Callback setters
# ----------------
proc `load=`*(n2d: Nim2d, load: proc (nim2d: Nim2d)) {.inline.} =
  n2d.load = load

proc `update=`*(n2d: Nim2d, update: proc (nim2d: Nim2d, dt: float)) {.inline.} =
  n2d.update = update

proc `draw=`*(n2d: Nim2d, draw: proc (nim2d: Nim2d)) {.inline.} =
  n2d.draw = draw

proc `quit=`*(n2d: Nim2d, quit: proc (nim2d: Nim2d)) {.inline.} =
  n2d.quit = quit

proc `keydown=`*(n2d: Nim2d, keydown: proc (nim2d: Nim2d, scancode: Scancode)) {.inline.} =
  n2d.keydown = keydown

proc `keyup=`*(n2d: Nim2d, keyup: proc (nim2d: Nim2d, scancode: Scancode)) {.inline.} =
  n2d.keyup = keyup

proc `mousemove=`*(n2d: Nim2d, mousemove: proc (nim2d: Nim2d, x, y, dx, dy: int32)) {.inline.} =
  n2d.mousemove = mousemove
  
proc `mousepressed=`*(n2d: Nim2d, mousepressed: proc(nim2d: Nim2d, x, y: int32, button, presses: uint8)) {.inline.} =
  n2d.mousepressed = mousepressed

proc `mousereleased=`*(n2d: Nim2d, mousereleased: proc(nim2d: Nim2d, x, y: int32, button, presses: uint8)) {.inline.} =
  n2d.mousereleased = mousereleased

# Window events
proc `window_shown=`*(n2d: Nim2d, window_shown: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_shown = window_shown

proc `window_hidden=`*(n2d: Nim2d, window_hidden: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_hidden = window_hidden

proc `window_moved=`*(n2d: Nim2d, window_moved: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_moved = window_moved

proc `window_resized=`*(n2d: Nim2d, window_resized: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_resized = window_resized

proc `window_size_changed=`*(n2d: Nim2d, window_size_changed: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_size_changed = window_size_changed

proc `window_minimized=`*(n2d: Nim2d, window_minimized: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_minimized = window_minimized

proc `window_maximized=`*(n2d: Nim2d, window_maximized: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_maximized = window_maximized

proc `window_restored=`*(n2d: Nim2d, window_restored: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_restored = window_restored

proc `window_enter=`*(n2d: Nim2d, window_enter: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_enter = window_enter

proc `window_leave=`*(n2d: Nim2d, window_leave: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_leave = window_leave

proc `window_focus_gained=`*(n2d: Nim2d, window_focus_gained: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_focus_gained = window_focus_gained

proc `window_focus_lost=`*(n2d: Nim2d, window_focus_lost: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_focus_lost = window_focus_lost

proc `window_close=`*(n2d: Nim2d, window_close: proc (nim2d: Nim2d)) {.inline.} =
  n2d.window_close = window_close


# Init
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
    width: width,
    height: height,
    background: background,
    color: color,
    window: window,
    renderer: renderer,
    fpsman: FpsManager(),
    running: true,

    load: proc (nim2d: Nim2d) = discard,
    update: proc (nim2d: Nim2d, dt: float) = discard,
    draw: proc (nim2d: Nim2d) = discard,
    quit: proc (nim2d: Nim2d) = discard,
    keydown: proc (nim2d: Nim2d, scancode: Scancode) = discard,
    keyup: proc (nim2d: Nim2d, scancode: Scancode) = discard,
    mousemove: proc(nim2d: Nim2d, x, y, dx, dy: int32) = discard,
    mousepressed: proc(nim2d: Nim2d, x, y: int32, button, presses: uint8) = discard,
    mousereleased: proc(nim2d: Nim2d, x, y: int32, button, presses: uint8) = discard,

    window_shown: proc (nim2d: Nim2d) = discard,
    window_hidden: proc(nim2d: Nim2d) = discard,
    window_moved: proc(nim2d: Nim2d) = discard,
    window_resized: proc(nim2d: Nim2d) = discard,
    window_size_changed: proc(nim2d: Nim2d) = discard,
    window_minimized: proc(nim2d: Nim2d) = discard,
    window_maximized: proc(nim2d: Nim2d) = discard,
    window_restored: proc(nim2d: Nim2d) = discard,
    window_enter: proc(nim2d: Nim2d) = discard,
    window_leave: proc(nim2d: Nim2d) = discard,
    window_focus_gained: proc(nim2d: Nim2d) = discard,
    window_focus_lost: proc(nim2d: Nim2d) = discard,
    window_close: proc(nim2d: Nim2d) = discard,
  ) 

proc newNim2d*(title: string, x, y, width, height: cint): Nim2d =
  newNim2d(title, x, y, width, height, (r: uint8 89, g: uint8 157, b: uint8 220, a: uint8 255))

proc play*(nim2d: Nim2d): void =
  nim2d.fpsman.init
  var evt = sdl2.defaultEvent

  nim2d.load(nim2d)

  while nim2d.running:
    while pollEvent(evt):
      case evt.kind:
        of QuitEvent:
          nim2d.quit(nim2d)
          nim2d.running = false
        of KeyDown:
          nim2d.keydown(nim2d, evt.key.keysym.scancode)
        of KeyUp:
          nim2d.keyup(nim2d, evt.key.keysym.scancode)
        of MouseMotion:
          nim2d.mousemove(nim2d, evt.motion.x, evt.motion.y, evt.motion.xrel, evt.motion.yrel)
        of MouseButtonDown:
          nim2d.mousepressed(nim2d, evt.button.x, evt.button.y, evt.button.button, evt.button.clicks)
        of MouseButtonUp:
          nim2d.mousereleased(nim2d, evt.button.x, evt.button.y, evt.button.button, evt.button.clicks)

        of WindowEvent:
          case evt.window.event:
            of WindowEvent_Shown:
              nim2d.window_shown(nim2d)
            of WindowEvent_Hidden:
              nim2d.window_hidden(nim2d)
            of WindowEvent_Moved:
              nim2d.window_moved(nim2d)
            of WindowEvent_Resized:
              nim2d.window_resized(nim2d)
            of WindowEvent_SizeChanged:
              nim2d.window_size_changed(nim2d)
            of WindowEvent_Minimized:
              nim2d.window_minimized(nim2d)
            of WindowEvent_Maximized:
              nim2d.window_maximized(nim2d)
            of WindowEvent_Restored:
              nim2d.window_restored(nim2d)
            of WindowEvent_FocusGained:
              nim2d.window_focus_gained(nim2d)
            of WindowEvent_FocusLost:
              nim2d.window_focus_lost(nim2d)
            of WindowEvent_Enter:
              nim2d.window_enter(nim2d)
            of WindowEvent_Leave:
              nim2d.window_leave(nim2d)
            of WindowEvent_Close:
              nim2d.window_close(nim2d)
            else:
              # echo(evt.window.event)
              discard
        else:
          # echo(evt)
          discard

    let dt = nim2d.fpsman.getFramerate() / 1000

    nim2d.renderer.setDrawColor(
      nim2d.background.r,
      nim2d.background.g,
      nim2d.background.b,
      nim2d.background.a
    )
    nim2d.renderer.clear()
    nim2d.draw(nim2d)
    nim2d.renderer.present
    nim2d.fpsman.delay
    nim2d.update(nim2d, dt)

  destroy nim2d.renderer
  destroy nim2d.window


func setColor*(nim2d: Nim2d, r, g, b, a: uint8) =
  nim2d.color = (r, g, b, a)
  
func setBackgroundColor*(nim2d: Nim2d, r, g, b: uint8) =
  nim2d.background = (r, g, b, uint8 255)
  nim2d.renderer.setDrawColor(
    nim2d.background.r,
    nim2d.background.g,
    nim2d.background.b,
    nim2d.background.a
  )
  nim2d.renderer.clear()

func setFont*(nim2d: Nim2d, font: Font) =
  nim2d.font = font

func setCanvas*(nim2d: Nim2d) =
  setRenderTarget(nim2d.renderer, nil)

func setCanvas*(nim2d: Nim2d, canvas: Canvas) =
  setRenderTarget(nim2d.renderer, canvas.data)

func setBlendMode*(nim2d: Nim2d, ) =
  setDrawBlendMode(nim2d.renderer, BlendMode_None)

func setBlendMode*(nim2d: Nim2d, blend: string) =
  var blending: BlendMode
  if blend == "blend":
    blending = BlendMode_Blend
  elif blend == "add":
    blending = BlendMode_Add
  elif blend == "mod":
    blending = BlendMode_Mod
  else:
    blending = BlendMode_None

  setDrawBlendMode(nim2d.renderer, blending)


func clear*(nim2d: Nim2d) =
  nim2d.setColor(255, 255, 255, 255)
  sdl2.clear(nim2d.renderer)  
