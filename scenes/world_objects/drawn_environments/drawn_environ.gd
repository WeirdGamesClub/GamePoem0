extends Node3D

@export var prompt: PromptResource
@onready var mesh = $MeshInstance3D


func _ready() -> void:
	await get_parent().get_parent().ready
	prompt.changed_drawing.connect(set_drawing)
	print(prompt.title)
	
func set_drawing(texture: Texture2D)->void:
	var material = StandardMaterial3D.new()
	material.albedo_texture = texture
	material.transparency= BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh.set_surface_override_material(0,material)
