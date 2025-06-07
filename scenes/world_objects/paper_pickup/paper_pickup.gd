extends Area3D

@export var prompt : PromptResource

func _on_body_entered(_body: Node3D) -> void:
	LevelSignal.emit_signal("pickup_signal",prompt)
	
	LevelSignal.emit_signal("prompt_removed", self)
	
	#Deletes on pickup
	queue_free()
