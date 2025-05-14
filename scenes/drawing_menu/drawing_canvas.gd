extends TextureRect

class_name DrawingCanvas

@export var brushPath: String
var imageBackgroundColor: Color = Color.TRANSPARENT
var brushImage: Image
var brushSize: int
var brushImageRect: Rect2i
var drawingImage: Image
var drawingTexture: ImageTexture

var currentColor: Color = Color.WHITE
var currentBrush: Image
var currentSize: int

enum {DRAWING, ERASING, STANDBY}

var currentState = STANDBY

func _ready() -> void:
	# initialize variables and make default image
	brushImage = load(brushPath).get_image()
	brushSize = brushImage.get_size().x
	brushImageRect = brushImage.get_used_rect()
	drawingImage = Image.create_empty(512, 512, true, Image.FORMAT_RGBA8)
	
	currentBrush = brushImage.duplicate()
	currentSize = brushSize
	
	drawingTexture = ImageTexture.create_from_image(drawingImage)
	self.set_texture(drawingTexture)
	
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
	

func _update_drawing(_delta: float, clickPos: Vector2) -> void:
	var editedCoords: Vector2i = Vector2i(clickPos) - brushImageRect.get_center()
	# this adds our "brush image" onto our "drawing image"
	drawingImage.blend_rect(currentBrush, brushImageRect, editedCoords)
	
	# update image texture (which will update sprite)
	drawingTexture.update(drawingImage)
	return
	
func change_brush_size(bsize: int) -> void:
	currentBrush.resize(bsize,bsize)
	currentSize = bsize
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
