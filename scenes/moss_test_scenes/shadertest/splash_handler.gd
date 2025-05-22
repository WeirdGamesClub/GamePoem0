extends Node3D

# get player position in UV space
# pipe to shader 

@export var viewportobj: SubViewport
@export var player: Node3D

var timer: float = 0.0

func _physics_process(delta: float) -> void:
	var playerpos = player.position
	viewportobj.set_splash_source((Vector2(playerpos.x, playerpos.z) + Vector2(1, 1)) / 2)

	var player_vel = player.get_player_vel()
	#print(player_vel)
	
	var timer_wait = 3 - (player_vel * 200)
	timer += delta
	if timer > timer_wait:
		viewportobj.make_ripple()
		timer -= timer_wait

		
