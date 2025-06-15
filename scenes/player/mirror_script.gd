extends Node3D

var player_sprite_M: Material
var player_drawing_M: Material
var mirror: Node3D

func _ready() -> void:
	var player = get_node("/root/Level/player_avatar/CharacterBody3D/")
	var player_sprite = player.get_node("outline_sprite")
	player_sprite_M = player_sprite.get_active_material(0)
	
	var player_drawing = player.get_node("MirrorDrawing/MeshInstance3D")
	player_drawing_M = player_drawing.get_active_material(0)
	
	LevelSignal.connect("mirror", mirror_collided)

func mirror_collided() -> void:
	print("mirror collided function called")
	var tween = get_tree().create_tween()
	tween.tween_property(player_sprite_M, "shader_parameter/alpha_multiplier", 0, 1)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(player_drawing_M, "shader_parameter/alpha_multiplier", 1, 1)
