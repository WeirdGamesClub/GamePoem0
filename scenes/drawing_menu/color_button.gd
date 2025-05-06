extends Button

class_name ColorButton

var currentColor : Color

func set_color(color: Color)->void:
	modulate = color
	currentColor = color

func _on_pressed() -> void:
	LevelSignal.emit_signal("change_color" , currentColor)
