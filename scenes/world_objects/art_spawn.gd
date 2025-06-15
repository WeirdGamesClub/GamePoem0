extends Node3D
class_name ArtSpawn
@export var NumRoundsToAppear: int = 1
@export var AdditionalFractionRound: float = 0.0
@export var EnableCollision: bool

@export var wave : int = 0
var player : PoemPlayer
var collision_shape: CollisionShape3D
var spawned: bool = false
var pickup: PaperPickup

func _ready() -> void:
	player = $"/root/Level/player_avatar/CharacterBody3D"
	collision_shape = get_child(0).get_node("CollisionShape3D")
	visible = false
	collision_shape.disabled = true
	if(get_child(0) is PaperPickup):
		pickup = get_child(0)

	
func _process(_delta: float) -> void:
	# stop updating after prompt has been spawned
	if(spawned == false):
		enable_prompt()

func enable_prompt() -> void:
	if(player.get_absoulte_progress() >= NumRoundsToAppear + AdditionalFractionRound and WaveManager.current_wave >= wave):
			visible = true
			if(EnableCollision == true):
				collision_shape.disabled = false
			spawned = true
			if(pickup):
				pickup.wave = wave
