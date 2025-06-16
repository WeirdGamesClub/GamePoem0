extends Node3D

@export var anim1: AnimationPlayer
@export var anim2: AnimationPlayer
@export var anim3: AnimationPlayer

@export var prompt: PromptResource

func _ready() -> void:
	anim1.pause()
	anim2.pause()
	anim3.pause()
	
	prompt.changed_drawing.connect(birds_drawn)
	
func birds_drawn(_drawing) -> void:
	print("birds_drawn")
	anim1.play()
	anim2.play()
	anim3.play()
	
