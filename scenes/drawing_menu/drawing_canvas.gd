extends TextureRect

class_name DrawingCanvas

@export var brushTexture: Texture2D
@export var brushSpacing: float = 0.01
var imageBackgroundColor: Color = Color(0.0, 0.0, 0.0, 0.0)
var brushImage: Image
var brushSize: int
var brushImageRect: Rect2i
var drawingImage: Image
var drawingTexture: ImageTexture

var currentColor: Color = Color.WHITE
var currentBrush: Image
var currentSize: int

var emptyImage: Image
var colorImage: Image

var brushTimer: float = 0

var _drawing_sfx_player : AudioStreamPlayer3D

var canvas_center : Vector2

enum {DRAWING, ERASING, STANDBY}

var currentState = STANDBY

func _ready() -> void:
	# initialize variables and make default image
	brushImage = brushTexture.get_image()
	if(brushImage.is_compressed()):
		brushImage.decompress()
	brushSize = brushImage.get_size().x
	brushImageRect = brushImage.get_used_rect()
	drawingImage = Image.create_empty(512, 512, false, Image.FORMAT_RGBA8)
	
	canvas_center = get_viewport_rect().size / 2
	
	currentBrush = brushImage.duplicate()
	currentSize = brushSize
	
	emptyImage = Image.create_empty(currentSize, currentSize, false, Image.FORMAT_RGBA8)
	emptyImage.fill(Color(0.0, 0.0, 0.0, 0.01)) #doesn't work with exactly 0 alpha

	colorImage = Image.create_empty(currentSize, currentSize, false, Image.FORMAT_RGBA8)
	colorImage.fill(Color(0.0, 0.0, 1.0, 1.0))

	drawingTexture = ImageTexture.create_from_image(drawingImage)
	self.set_texture(drawingTexture)
	
	_drawing_sfx_player = get_node("AudioStreamPlayer3D")
	
	LevelSignal.connect("change_color", change_color)
	LevelSignal.connect("start_erasing", start_erasing)
	
	return

func _process(delta: float) -> void:
	if(InputManager.input_mode != InputManager.mode.DRAWING):
		return
		
	var mouse_pos = get_local_mouse_position()
	
	var in_canvas = (mouse_pos.x < 512) and (mouse_pos.y < 512) and (mouse_pos.x > 0) and (mouse_pos.y > 0)
	
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and in_canvas):
		match currentState:
			DRAWING:
				_update_drawing(delta, mouse_pos)
			ERASING:
				_erase_drawing(mouse_pos)
		
		if(!_drawing_sfx_player.playing):
			_drawing_sfx_player.play(randf()* 2)
	else:
		_drawing_sfx_player.stop()

func _update_drawing(_delta: float, clickPos: Vector2) -> void:
	var editedCoords: Vector2i = Vector2i(clickPos) - brushImageRect.get_center()
	
	# this adds our "brush image" onto our "drawing image"
	drawingImage.blit_rect_mask(colorImage, currentBrush, brushImageRect, editedCoords)

	# update image texture (which will update sprite)
	drawingTexture.update(drawingImage)
	return

func _erase_drawing(clickPos: Vector2) -> void:
	var editedCoords: Vector2i = Vector2i(clickPos) - brushImageRect.get_center()

	drawingImage.blit_rect_mask(emptyImage, currentBrush, brushImageRect, editedCoords)
	
	# update image texture (which will update sprite)
	drawingTexture.update(drawingImage)
	return

func start_drawing(startingColor: Color) -> void:	
	# fill with a background color
	drawingImage.fill(imageBackgroundColor)
	drawingTexture.update(drawingImage)
	
	#TEST
	change_brush_size(56)
	
	change_color(startingColor)
	brushTimer = 0
	currentState = DRAWING

func change_brush_size(bsize: int) -> void:
	currentBrush.resize(bsize,bsize, Image.INTERPOLATE_NEAREST)
	emptyImage.resize(bsize, bsize, Image.INTERPOLATE_NEAREST)
	colorImage.resize(bsize, bsize, Image.INTERPOLATE_NEAREST)
	currentSize = bsize
	brushImageRect = currentBrush.get_used_rect()
	return	

func change_color(color: Color) -> void:
	currentState = DRAWING
	
	colorImage.fill(color)
	
	currentColor = color
	
	return

func start_erasing() -> void:
	currentState = ERASING
	return

func pull_drawing() -> Texture2D:
	_drawing_sfx_player.stop()
	return ImageTexture.create_from_image(drawingImage)
