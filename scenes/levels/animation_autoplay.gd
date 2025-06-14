extends AnimationPlayer

@export var anim_to_play : String

func _ready() -> void:
	play(anim_to_play)
