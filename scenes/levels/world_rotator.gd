extends Camera3D
@export var player : Node3D
@export var world : Node3D

@export var rotateSpeed : float = 100

@export var boundsScale : Vector2 = Vector2(3.5,3)

func _process(delta: float) -> void:
	#check to see if the player is within the bounds
	var position = unproject_position(player.transform.origin)
	
	var height = get_viewport().get_visible_rect().size.y
	
	
	var bounds = Vector2( height / boundsScale.x, height / boundsScale.y)

	#if outside, rotate world
	
	#if(position.y < bounds.x):
		#rotate world negatively
	#world.transform = world.transform.rotated(Vector3.RIGHT, -rotateSpeed * delta)
	#elif(position.y > bounds.y):
		#rotate world positively
		#world.transform = world.transform.rotated(Vector3.RIGHT, rotateSpeed * delta)
