extends Node3D

@export var prompt: PromptResource
@export var primary_color: Color
@export var secondary_color: Color
@onready var mesh = $MeshInstance3D


func _ready() -> void:
	await get_parent().get_parent().ready
	prompt.changed_drawing.connect(set_drawing)
	
func set_drawing(texture: Texture2D)->void:
	var material = mesh.get_active_material(0)
	
	material.set_shader_parameter("drawing_texture", texture)
	material.set_shader_parameter("primary_color", primary_color)
	material.set_shader_parameter("secondary_color", secondary_color)
