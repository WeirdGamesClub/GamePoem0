extends TextureRect

@export var rounds_to_expire : float

var player : PoemPlayer

func _ready() -> void:
	player = $"/root/Level/player_avatar/CharacterBody3D"
	

func _process(_delta: float) -> void:
	if(OS.has_feature("web_android")||OS.has_feature("web_ios")):
		queue_free()
	
	if(player.get_absoulte_progress() >= rounds_to_expire ):
		queue_free()
