extends TextureRect

class_name DrawingCanvas

@export var brushPath: String
@export var imageBackgroundColor: Color = Color(1, 1, 1)
var brushImage: Image
var brushSize: float
var brushImageRect: Rect2i
var drawingImage: Image
var drawingTexture: ImageTexture

var currentColor: Color = Color.WHITE
var currentBrush: Image
var currentSize: float

enum {DRAWING, ERASING, STANDBY}

var currentState = STANDBY

func _ready() -> void:
	# initialize variables and make default image
	brushImage = Image.load_from_file(brushPath)
	brushSize = brushImage.get_size().x
	brushImageRect = brushImage.get_used_rect()
	drawingImage = Image.create_empty(512, 512, true, Image.FORMAT_RGBA8)
	
	currentBrush = Image.load_from_file(brushPath)
	currentSize = brushSize
	
	drawingTexture = ImageTexture.create_from_image(drawingImage)
	set_texture(drawingTexture)
	
	LevelSignal.connect("change_color", change_color)
	
	return

func _process(delta: float) -> void:
	#if active
	#accepts drawing input
	match currentState:
		DRAWING:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				_update_drawing(delta, get_local_mouse_position())

func start_drawing() -> void:	
	# fill with a background color
	drawingImage.fill(imageBackgroundColor)
	currentState = DRAWING
	

func _update_drawing(delta: float, clickPos: Vector2) -> void:
	var editedCoords: Vector2i = Vector2i(clickPos) - brushImageRect.get_center()
	# this adds our "brush image" onto our "drawing image"
	drawingImage.blend_rect(currentBrush, brushImageRect, editedCoords)
	
	# update image texture (which will update sprite)
	drawingTexture.update(drawingImage)
	return
	
func change_brush_size(size: float) -> void:
	currentBrush.resize(size,size)
	currentSize = size
	brushImageRect = currentBrush.get_used_rect()
	return	

func change_color(color: Color) -> void:
	currentBrush.resize(brushSize,brushSize)
	
	for y in brushSize:
		for x in brushSize:
			if(brushImage.get_pixel(x,y).a !=0) :
				currentBrush.set_pixel(x,y, color * brushImage.get_pixel(x,y))
	
	currentColor = color
	currentBrush.resize(currentSize,currentSize)
	return
