extends TextureRect

@export var brushPath: String
@export var imageBackgroundColor: Color = Color(1, 1, 1)
var brushImage: Image
var brushImageRect: Rect2i
var drawingImage: Image
var drawingTexture: ImageTexture

# STRETCH TODO: colors?
# STRETCH TODO: limit the number of times this draws (as opposed to once per frame)
# if we want different brush sizes, probably easiest way to do that is by swapping brush texture
# with love, moss

func _ready() -> void:
	setup_image()

func _process(_delta) -> void:
	# get mouse position when mouse button is pressed down
	# call update image
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
	
		# use local space of texture we're drawing on
		var mousePos: Vector2 = get_local_mouse_position()	
		print("mouse position: ", mousePos)
		update_image(mousePos)

func setup_image() -> void:
	# initialize variables and make default image
	brushImage = Image.load_from_file(brushPath)
	brushImageRect = brushImage.get_used_rect()
	drawingImage = Image.create_empty(512, 512, true, Image.FORMAT_RGBA8)
	
	# fill with a random color
	drawingImage.fill(imageBackgroundColor)

	# make ImageTexture from image
	# assign to sprite texture
	drawingTexture = ImageTexture.create_from_image(drawingImage)
	set_texture(drawingTexture)
	
func update_image(clickPos) -> void:
	#clickPos should be the mouse clicked position in local space of parent sprite
	
	# account for offset 
	# TODO: pretty sure this doesn't work for non-square images
	var editedCoords: Vector2i = Vector2i(clickPos) - brushImageRect.get_center()
	print("edited coordinates are", editedCoords)
	
	# this adds our "brush image" onto our "drawing image"
	drawingImage.blend_rect(brushImage, brushImageRect, editedCoords)
	
	# update image texture (which will update sprite)
	drawingTexture.update(drawingImage)
 
func finish_image() -> PackedByteArray:
	# called by outer scene on a button click / other trigger
	var finishedImage: PackedByteArray = drawingImage.save_png_to_buffer()
	return finishedImage
