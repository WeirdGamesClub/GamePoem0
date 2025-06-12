extends AudioStreamPlayer3D

func _ready() -> void:
	AudioSignal.foot_SFX.connect(play)
	
