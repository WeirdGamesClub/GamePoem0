extends Button


func _on_pressed() -> void:
	LevelSignal.emit_signal("start_erasing")
	pass
