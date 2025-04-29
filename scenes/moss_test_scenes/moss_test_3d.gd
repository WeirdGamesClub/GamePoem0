extends Node3D

func _on_button_pressed() -> void:
	var drawnImageBuffer: PackedByteArray = $TestDrawingUi.finish_image()
	
	#UI cleanup.. I think
	$TestDrawingUi.release_focus() #theoretically releasing UI input but idk how this works really
	$TestDrawingUi.set_visible(false)
	
	set_drawing_as_texture(drawnImageBuffer)
	

func set_drawing_as_texture(imageBuffer: PackedByteArray) -> void:
	# loads buffer into Image, uses Image to create ImageTexture, sets texture of mesh
	var loadedImage: Image = Image.new()
	loadedImage.load_png_from_buffer(imageBuffer)
	var drawnTexture: Texture2D = ImageTexture.create_from_image(loadedImage)
	$TestPainting.get_active_material(0).set_texture(BaseMaterial3D.TEXTURE_ALBEDO, drawnTexture)
