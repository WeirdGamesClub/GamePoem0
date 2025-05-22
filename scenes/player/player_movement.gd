class_name PoemPlayer
extends CharacterBody3D

@export var world : Node3D
@export var walkSpeed: float = 0.5
var rotateSpeedRadian : float = 0.0 #gets set from walk speed on _ready()

var cyllinderRadius : float
var cyllinderCenter : Vector3
var cyllinder_rotate_axis : Vector3
var currentround_angle_travelled_degrees: float = 0 
var round_count: int = 0
	
func _get_angle_between_vecs(vecA_normalized: Vector3, vecB_normalized: Vector3)->float:
	var angle = acos(vecA_normalized.dot((vecB_normalized)));
	return rad_to_deg(angle)
		
func _get_cyllinder_normal(playerPos: Vector3) -> Vector3:
	var centerToPlayer = playerPos - cyllinderCenter
	var playerOffsetAlongCyllinderRotateAxis = centerToPlayer.project(cyllinder_rotate_axis)
	#now we can consider the cyllinder flattened into a circle for this part of the logic
	var centerToPlayerFlat = centerToPlayer - playerOffsetAlongCyllinderRotateAxis
	return centerToPlayerFlat.normalized()
	
func _get_cyllinder_corrected_position(playerPos: Vector3, currentNormal: Vector3) -> Vector3:
	#now we can consider the cyllinder flattened into a circle for this part of the logic
	var playerPosOnCircle = cyllinderCenter + (currentNormal * cyllinderRadius)
	#extend it back out to cyllinder:
	var centerToPlayer = playerPos - cyllinderCenter
	var playerOffsetAlongCyllinderRotateAxis = centerToPlayer.project(cyllinder_rotate_axis)
	var playerPosOnCylinder = playerPosOnCircle + playerOffsetAlongCyllinderRotateAxis
	return playerPosOnCylinder
	
func _ready() -> void:
	cyllinderRadius = world.transform.basis.get_scale().x/2 + 0.05 #TODO: this should be off of initial player distance :)
	cyllinderCenter = Vector3(0,0,0)
	cyllinder_rotate_axis = Vector3.RIGHT
	rotateSpeedRadian = (walkSpeed / cyllinderRadius)
	
func _physics_process(delta: float) -> void:
	if(InputManager.input_mode != InputManager.mode.WALKING): 
		return
	
	var playerPosBeforeUpdate =  self.global_position

	var cylNormalBeforeUpdate = _get_cyllinder_normal(playerPosBeforeUpdate)
	var playerAngleFromUp = cylNormalBeforeUpdate.angle_to(Vector3.UP)
	var horInput = Input.get_axis("move_left","move_right")
	var vertInput = Input.get_axis("move_down","move_up")
	#horizontal bounds:
	if(playerPosBeforeUpdate.x >= 0.95 && horInput > 0):
		horInput = 0
	if(playerPosBeforeUpdate.x <= -0.95 && horInput < 0):
		horInput = 0	
		
	#setting the step basis before updating
	get_parent().transform.basis.y = cylNormalBeforeUpdate #sets transform up vector
	get_parent().transform.basis.z = cylNormalBeforeUpdate.cross(get_parent().transform.basis.x)
	
	#the update to take the step in
	
	#Rotate the world if the player is at bounds	
	if(playerAngleFromUp >= deg_to_rad(60) && vertInput < 0):
		world.transform = world.transform.rotated(Vector3.RIGHT, -rotateSpeedRadian * delta)
		currentround_angle_travelled_degrees = currentround_angle_travelled_degrees - rad_to_deg(rotateSpeedRadian * delta)
		vertInput = 0
	elif(playerAngleFromUp <= deg_to_rad(10) && vertInput > 0):
		world.transform = world.transform.rotated(Vector3.RIGHT, rotateSpeedRadian * delta)
		currentround_angle_travelled_degrees = currentround_angle_travelled_degrees + rad_to_deg(rotateSpeedRadian * delta)
		vertInput = 0
		
	#Move the player along the surface of cyllinder 
	var inputStepHorizontal = horInput * get_parent().transform.basis.x  * walkSpeed * delta 
	var inputStepVertical = vertInput * get_parent().transform.basis.z * walkSpeed * delta 
	var inputStep = inputStepHorizontal + inputStepVertical
	var playerPosAfterUpdate = playerPosBeforeUpdate + inputStep	
	var cylNormalAfterUpdate = _get_cyllinder_normal(playerPosAfterUpdate)
	#fix the player position so they dont run off the cyllinders radius
	self.global_position = _get_cyllinder_corrected_position(playerPosAfterUpdate,cylNormalAfterUpdate)
		
	#calculate degrees traveled
	if(vertInput > 0):
		currentround_angle_travelled_degrees = currentround_angle_travelled_degrees + _get_angle_between_vecs(cylNormalBeforeUpdate, cylNormalAfterUpdate)
	elif(vertInput < 0):
		currentround_angle_travelled_degrees = currentround_angle_travelled_degrees - _get_angle_between_vecs(cylNormalBeforeUpdate, cylNormalAfterUpdate)

	if(currentround_angle_travelled_degrees >= 365 || currentround_angle_travelled_degrees <= -365):
		round_count = round_count + 1;
		currentround_angle_travelled_degrees = 0
	move_and_slide()
