extends Area3D

var player_sprite: Sprite3D
var player_drawing: Node3D

func _ready() -> void:
	var player = get_node("/root/Level/player_avatar/CharacterBody3D/")
	player_sprite = player.get_node("Sprite3D")
	player_drawing = player.get_node("MirrorDrawing")

func _on_body_entered(body: Node3D) -> void:
	#player_sprite.visible = false
	#player_drawing.visible = true
	pass
