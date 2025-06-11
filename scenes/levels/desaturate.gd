extends WorldEnvironment

@export var desaturate_collider: Node3D
@export var resaturate_collider: Node3D

var saturation = 1
var tween

func _ready() -> void:
	LevelSignal.connect("desaturate", desaturate)
	LevelSignal.connect("resaturate", resaturate)

func desaturate() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(self, "adjustment_saturation", 0, 6)
	
func resaturate() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "adjustment_saturation", 1, 6)
