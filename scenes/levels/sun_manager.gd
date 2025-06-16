# YES this script is basically a copy-paste of the birds one
# NO i am not going to be a better engineer
# - lovingly, moss

extends Node3D

@export var anim1: AnimationPlayer

@export var prompt: PromptResource

func _ready() -> void:
	anim1.pause()
	prompt.changed_drawing.connect(sun_drawn)
	
func sun_drawn(_drawing) -> void:
	print("sun_drawn")
	anim1.play("sunrise")
