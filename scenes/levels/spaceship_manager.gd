extends Node3D

@export var happiness_prompt: PromptResource
@export var animplayer: AnimationPlayer

func _ready() -> void:
	animplayer.pause()
	happiness_prompt.changed_drawing.connect(play_anim)
	
func play_anim(_drawing) -> void:
	print("sun_drawn")
	animplayer.play("spaceship")
