extends Area3D

var collision 
var material

func _ready() -> void:
	collision = self.get_child(0)
	material = self.get_child(1).get_active_material(0)

func _on_body_entered(_body: Node3D) -> void:
	LevelSignal.emit_signal("mirror")
	set_deferred("disabled", true)
	
	var tween = get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/alpha_multiplier", 0, 1)

	print("collided")
