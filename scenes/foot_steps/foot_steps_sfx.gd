extends AudioStreamPlayer3D

func _ready() -> void:
	AudioSignal.foot_SFX.connect(_play_footstep)
	
func _play_footstep()->void:
	await get_tree().create_timer(0.01).timeout
	play()
