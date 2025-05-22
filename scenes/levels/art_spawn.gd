extends MeshInstance3D
@export var NumRoundsToAppear: float = 1.0
@export var player : Node3D

func _ready() -> void:
	visible = false
	
func _process(_delta: float) -> void:
	if(player is PoemPlayer):
		if(abs(player.round_count) >= NumRoundsToAppear ):
			visible = true
