extends MeshInstance3D
@export var NumRoundsToAppear: int = 1
@export var player : Node3D

func _ready() -> void:
	visible = false
	
func _process(delta: float) -> void:
	if(player is PoemPlayer):
		if(player.total_angle_travelled_degrees >= (NumRoundsToAppear * 360)):
			visible = true
