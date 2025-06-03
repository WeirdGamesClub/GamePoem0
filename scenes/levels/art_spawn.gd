extends MeshInstance3D
@export var NumRoundsToAppear: int = 1
@export var AdditionalFractionRound: float = 0.0
@export var player : Node3D

func _ready() -> void:
	visible = false
	
func _process(_delta: float) -> void:
	if(player is PoemPlayer):
		if(abs(player.round_count) >= NumRoundsToAppear ):
			var additionalfraction = abs(player.currentround_angle_travelled_degrees) /360
			if(additionalfraction >= AdditionalFractionRound ):
				visible = true
