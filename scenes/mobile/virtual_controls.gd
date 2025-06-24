extends CanvasLayer

func _process(delta: float) -> void:
	if(!(OS.has_feature("web_android")||OS.has_feature("web_ios"))):
		if(visible):
			visible = false
		return
	
	if(InputManager.input_mode != InputManager.mode.WALKING):
		visible = false
	else:
		visible = true
	return
