extends StaticBody3D

@export var prompt: PromptResource
@export var mesh: MeshInstance3D


func _ready() -> void:
	prompt.changed_drawing.connect(set_drawing)
	
func set_drawing(texture: Texture2D)->void:
	var material = StandardMaterial3D.new()
	material.albedo_texture = texture
	material.transparency= BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh.set_surface_override_material(0,material)
