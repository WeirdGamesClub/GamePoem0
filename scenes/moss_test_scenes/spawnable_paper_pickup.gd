extends Node3D

func _process(_delta: float) -> void:
	# well fuck me i guess it just doesnt really work man
	pass

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	
	if self.rotation.x != 0:
		warnings.append("spawnable is rotated in x")
		
	if self.rotation.z != 0:
		warnings.append("spawnable is rotated in z")
		
	if self.position.x != 0:
		warnings.append("spawnable is moved in x")
		
	if self.position.z != 0:
		warnings.append("spawnable is moved in z")
	
	warnings.append("test")
	
	return warnings
	
