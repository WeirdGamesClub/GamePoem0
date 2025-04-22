class_name GroundCast

extends RayCast3D

var collsionNormal : Vector3

func _physics_process(delta: float) -> void:
	
	if(!is_colliding()): return
	
	collsionNormal = get_collision_normal()
	
