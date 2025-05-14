extends MeshInstance3D
@export var NumRoundsToAppear: float = 1.0
@export var player : Node3D

func _ready() -> void:
	visible = false
	
func _process(_delta: float) -> void:
	if(player is PoemPlayer):
		if(player.total_angle_travelled_degrees >= (NumRoundsToAppear * 360)):
			visible = true
