extends Node2D

@export var brushPath: String
@export var imageBackgroundColor = Color(1, 1, 1)
var brushImage: Image
var brushImageRect: Rect2i
var drawingImage: Image
var drawingTexture: ImageTexture

# TODO: figure out what variables should be global or whatever idk how to make "clean code"
# TODO: figure out how to save final image to a resource that can be used as textures on many different sprites
# STRETCH TODO: more colors?
# STRETCH TODO: limit the number of times this draws (as opposed to once per frame)
# with love, moss

func _ready():
	setup_image()

func _process(_delta):
	# get mouse position when mouse button is pressed down
	# call update image
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		
		# use local space of sprite we're drawing on
		var mousePos = $TestSprite.get_local_mouse_position()
		print("mouse click at", mousePos)
		
		update_image(mousePos)

func setup_image():
	# initialize variables and make default image
	brushImage = Image.load_from_file(brushPath)
	brushImageRect = brushImage.get_used_rect()
	drawingImage = Image.create_empty(512, 512, true, Image.FORMAT_RGBA8)
	
	# fill with a random color
	drawingImage.fill(imageBackgroundColor)

	# make ImageTexture from image
	# assign to sprite texture
	drawingTexture = ImageTexture.create_from_image(drawingImage)
	$TestSprite.set_texture(drawingTexture)
	
	print("yeah this runs")

func update_image(clickPos):
	#clickPos should be the mouse clicked position in local space of parent sprite
	
	# account for offset 
	# 250,250 is currently a magic number that should be adjusted to 1/2 image size
	var editedCoords = Vector2i(clickPos) + Vector2i(250, 250) - brushImageRect.get_center()
	print("edited coordinates are", editedCoords)
	
	# this adds our "brush image" onto our "drawing image"
	drawingImage.blend_rect(brushImage, brushImageRect, editedCoords)
	
	# update image texture (which will update sprite)
	drawingTexture.update(drawingImage)

func finish_image():
	var finishedImage = drawingImage.save_png_to_buffer()
	return finishedImage
	
