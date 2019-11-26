import sdl2, sdl2/ttf, sdl2/gfx

type
  Drawable* = ref object of RootObj

type
  Texture* = ref object of Drawable
    data*: TexturePtr
    width*: cint
    height*: cint

type
  Image* = ref object of Texture
    texture*: TexturePtr
    # width: cint
    # height: cint

type
  Canvas* = ref object of Image


type
  Font* = object
    address*: FontPtr
    filename*: cstring
    size*: cint

type
  Nim2d* = ref object
    width*: cint
    height*: cint
    window*: WindowPtr
    renderer*: RendererPtr
    background*: tuple[r, g, b, a: uint8]
    color*: tuple[r, g, b, a: uint8]
    font*: Font
    fpsman*: FpsManager
    running*: bool

    # Callbacks
    load*: proc(nim2d: Nim2d)
    draw*: proc(nim2d: Nim2d)
    quit*: proc(nim2d: Nim2d)
    update*: proc(nim2d: Nim2d, dt: float)
    keydown*: proc(nim2d: Nim2d, scancode: Scancode)
    keyup*: proc(nim2d: Nim2d, scancode: Scancode)
    mousemove*: proc(nim2d: Nim2d, x, y, dx, dy: int32)
    mousepressed*: proc(nim2d: Nim2d, x, y: int32, button, presses: uint8)
    mousereleased*: proc(nim2d: Nim2d, x, y: int32, button, presses: uint8)

    # Window events
    window_shown*: proc(nim2d: Nim2d)
    window_hidden*: proc(nim2d: Nim2d)
    window_moved*: proc(nim2d: Nim2d)
    window_resized*: proc(nim2d: Nim2d)
    window_size_changed*: proc(nim2d: Nim2d)
    window_minimized*: proc(nim2d: Nim2d)
    window_maximized*: proc(nim2d: Nim2d)
    window_restored*: proc(nim2d: Nim2d)
    window_enter*: proc(nim2d: Nim2d)
    window_leave*: proc(nim2d: Nim2d)
    window_focus_gained*: proc(nim2d: Nim2d)
    window_focus_lost*: proc(nim2d: Nim2d)
    window_close*: proc(nim2d: Nim2d)
