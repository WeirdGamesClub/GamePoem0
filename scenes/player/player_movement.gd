extends CharacterBody3D

var ground_cast: GroundCast

@export var speed: float

func _enter_tree() -> void:
	ground_cast = get_node("RayCast3D")
	
func _physics_process(delta: float) -> void:
	
	#Calculate the direction which the player can move
	
	#TODO: get input from player
	
	var horInput = Input.get_axis("move_left","move_right")
	var vertInput = Input.get_axis("move_up","move_down")
	
	var inputDir = Vector3(horInput,0,vertInput).normalized() #PLACEHOLDER Forward vector
	
	#the normal from the cylinder
	var normal = ground_cast.collsionNormal
	
	if(normal.length_squared() == 0): 
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	var proj = inputDir.project(normal)
	
	var moveDir = inputDir - proj
	
	#transform = transform.basis.looking_at(global_transform.origin + moveDir)
	
	velocity = moveDir.normalized() * speed * delta
	
	move_and_slide()
	
	
