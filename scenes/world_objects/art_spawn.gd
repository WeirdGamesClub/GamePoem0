extends Node3D
@export var NumRoundsToAppear: int = 1
@export var AdditionalFractionRound: float = 0.0
var player : PoemPlayer

func _ready() -> void:
	player = $"/root/Level/player_avatar/CharacterBody3D"
	visible = false
	
func _process(_delta: float) -> void:

	if(abs(player.round_count) >= NumRoundsToAppear ):
		var additionalfraction = abs(player.currentround_angle_travelled_degrees) /360
		if(additionalfraction >= AdditionalFractionRound ):
			visible = true
