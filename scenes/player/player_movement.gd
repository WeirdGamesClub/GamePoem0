extends CharacterBody3D

@export var world : Node3D
@export var speed: float
@export var rotateSpeed : float 

func _get_cyllinder_normal(playerPos: Vector3, cyllinderCenter: Vector3, cyllinder_rotate_axis: Vector3 ) -> Vector3:
	var centerToPlayer = playerPos - cyllinderCenter
	var playerOffsetAlongCyllinderRotateAxis = centerToPlayer.project(cyllinder_rotate_axis)
	#now we can consider the cyllinder flattened into a circle for this part of the logic
	var centerToPlayerFlat = centerToPlayer - playerOffsetAlongCyllinderRotateAxis
	return centerToPlayerFlat.normalized()
	
func _get_cyllinder_corrected_position(playerPos: Vector3, cyllinderCenter: Vector3, cyllinder_rotate_axis: Vector3, currentNormal: Vector3, cyllinderRadius: float) -> Vector3:
	#now we can consider the cyllinder flattened into a circle for this part of the logic
	var playerPosOnCircle = cyllinderCenter + (currentNormal * cyllinderRadius)
	#extend it back out to cyllinder:
	var centerToPlayer = playerPos - cyllinderCenter
	var playerOffsetAlongCyllinderRotateAxis = centerToPlayer.project(cyllinder_rotate_axis)
	var playerPosOnCylinder = playerPosOnCircle + playerOffsetAlongCyllinderRotateAxis
	return playerPosOnCylinder
	
func _physics_process(delta: float) -> void:
	

	#Calculate the direction which the player can move
	
	#TODO: get input from player
	var cyllinderRadius = 0.55
	var cyllinderCenter = Vector3(0,0,0)
	var cyllinder_rotate_axis = Vector3.RIGHT
	
	var playerPos =  self.global_position

	var currentCylNormal = _get_cyllinder_normal(playerPos,cyllinderCenter,cyllinder_rotate_axis)
	var playerAngleFromUp = currentCylNormal.angle_to(Vector3.UP)
	var horInput = Input.get_axis("move_left","move_right")
	var vertInput = Input.get_axis("move_down","move_up")
	#horizontal bounds:
	if(playerPos.x >= 0.95 && horInput > 0):
		horInput = 0
	if(playerPos.x <= -0.95 && horInput < 0):
		horInput = 0	
		
	if(playerAngleFromUp >= deg_to_rad(80) && vertInput < 0):
		world.transform = world.transform.rotated(Vector3.RIGHT, -rotateSpeed * delta)
	elif(playerAngleFromUp <= deg_to_rad(10) && vertInput > 0):
		world.transform = world.transform.rotated(Vector3.RIGHT, rotateSpeed * delta)
	else:	
		get_parent().transform.basis.y = currentCylNormal #sets transform up vector
		get_parent().transform.basis.z = currentCylNormal.cross(get_parent().transform.basis.x)
		var forward = get_parent().transform.basis.z 

	
		var inputStep = ((horInput * get_parent().transform.basis.x ) + (vertInput * get_parent().transform.basis.z )).normalized() * speed * delta 
		var movedPlayer = playerPos + inputStep
	
		var newCylNormal = _get_cyllinder_normal(movedPlayer,cyllinderCenter,cyllinder_rotate_axis)
		#fix the player position so they dont run off the cyllinders radius
		self.global_position =  _get_cyllinder_corrected_position(movedPlayer,cyllinderCenter,cyllinder_rotate_axis,newCylNormal,cyllinderRadius)
	

		
	

	

	
	
