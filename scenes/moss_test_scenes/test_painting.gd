extends MeshInstance3D

# painting number is currently set by order that paintings are made in
# TODO: make it so you can match up painting to number regardless of creation order
@export var receivesPaintingNumber: int

func _ready() -> void:
	#TODO: can we make this not hardcoded to get parent
	get_parent().painting_completed.connect(_on_painting_completed) #bind to signal

func _on_painting_completed(painting: PackedByteArray, number: int) -> void:
	if(number == receivesPaintingNumber):
		set_drawing_as_texture(painting)

func set_drawing_as_texture(imageBuffer: PackedByteArray) -> void:
	# loads buffer into Image, uses Image to create ImageTexture, sets texture of mesh
	var loadedImage: Image = Image.new()
	loadedImage.load_png_from_buffer(imageBuffer)
	var drawnTexture: Texture2D = ImageTexture.create_from_image(loadedImage)
	get_active_material(0).set_texture(BaseMaterial3D.TEXTURE_ALBEDO, drawnTexture)
