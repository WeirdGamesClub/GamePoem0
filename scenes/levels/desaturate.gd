extends WorldEnvironment

@export var desaturation_timer: float = 15
@export var saturation_timer: float = 6

var saturation = 1
var tween

func _ready() -> void:
	LevelSignal.connect("desaturate", desaturate)
	LevelSignal.connect("resaturate", resaturate)

func desaturate() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(environment, "adjustment_saturation", 0.2, desaturation_timer)
	
func resaturate() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(environment, "adjustment_saturation", 1, saturation_timer)
