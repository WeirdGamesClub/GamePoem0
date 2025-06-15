extends Area3D
class_name PaperPickup
@export var prompt : PromptResource
@export var wave : int

func _on_body_entered(_body: Node3D) -> void:
	LevelSignal.emit_signal("pickup_signal",prompt)
	
	LevelSignal.emit_signal("prompt_removed", self)
	
	WaveManager.pickup(wave)
	
	#Deletes on pickup
	queue_free()
