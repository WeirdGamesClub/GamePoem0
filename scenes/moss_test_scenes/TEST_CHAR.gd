extends CharacterBody3D

@export var walkSpeed = .5

var inputStep: Vector3

func _physics_process(delta: float) -> void:
	var horInput = Input.get_axis("move_left","move_right")
	var vertInput = Input.get_axis("move_down","move_up")

	var inputStepHorizontal = horInput * get_parent().transform.basis.x * walkSpeed * delta 
	var inputStepVertical = -vertInput * get_parent().transform.basis.z * walkSpeed * delta 
	inputStep = inputStepHorizontal + inputStepVertical

	self.global_position += inputStep

func get_player_vel() -> float:
	return inputStep.length()
