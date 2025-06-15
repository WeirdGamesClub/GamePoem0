extends Node3D

@export var wave : int = 0 

func _ready() -> void:
	WaveManager.new_wave.connect(_wave_check)
	propagate_call("set", ["disabled", true])
	
func _wave_check(num: int)->void:
	if(num >= wave ):
		#activate children somehow
		propagate_call("set", ["disabled", false])
		pass
