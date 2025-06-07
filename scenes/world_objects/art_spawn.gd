extends Node3D
@export var NumRoundsToAppear: int = 1
@export var AdditionalFractionRound: float = 0.0
@export var EnableCollision: bool

var player : PoemPlayer
var collision_shape: CollisionShape3D
var spawned: bool = false

func _ready() -> void:
	player = $"/root/Level/player_avatar/CharacterBody3D"
	collision_shape = get_child(0).get_node("CollisionShape3D")
	visible = false
	collision_shape.disabled = true
	
func _process(_delta: float) -> void:
	# stop updating after prompt has been spawned
	if(spawned == false):
		enable_prompt()

func enable_prompt() -> void:
	if(abs(player.round_count) >= NumRoundsToAppear ):
		var additionalfraction = abs(player.currentround_angle_travelled_degrees) /360
		if(additionalfraction >= AdditionalFractionRound ):
			visible = true
			if(EnableCollision == true):
				collision_shape.disabled = false
			spawned = true
			LevelSignal.emit_signal("prompt_added", get_child(0))
