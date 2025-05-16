extends StaticBody3D

@export var prompt: PromptResource
@export var sprite: Sprite3D

func _ready() -> void:
	prompt.changed_drawing.connect(set_drawing)
	
func set_drawing(texture: Texture2D)->void:
	sprite.texture = texture
