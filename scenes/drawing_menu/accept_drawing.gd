extends Button

var _sfx_player :AudioStreamPlayer3D

func _ready() -> void:
	_sfx_player = get_node("AudioStreamPlayer3D")
	
func play() ->void:
	_sfx_player.play()
