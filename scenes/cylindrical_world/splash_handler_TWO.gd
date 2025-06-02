extends Node3D
 
@export var player: Node3D
@export var ground_mesh: MeshInstance3D;
@export var max_interval_btwn_splashes: float = 2.1
@export var max_distance_btwn_splashes: float = 0.14
@export var splash_duration: float = 2
@export var splash_radius: float = 0.15
@export var splash_width: float = 0.01
@export var test: Vector3 = Vector3(0.2, 0.4, 0.6)

@export var debug_sphere: Node3D

# must correspond to array length in shader
# this number has to be hard-coded to the shader so it's hard coded here too
var splash_array_max_length: int = 8

var ground_material: Material

var debug_sphere_material: Material

var splash_positions: Array[Vector3]
var splash_times: Array[float]

var timer: float
var dist_traveled: float = 0;
var curr_array_index: int = 0;

func _ready() -> void:
	# set shader parameters from script variables
	ground_material = ground_mesh.get_active_material(0)
	ground_material.set_shader_parameter("rip_radius", splash_radius)
	ground_material.set_shader_parameter("rip_width", splash_width)
	ground_material.set_shader_parameter("test_color", test)
		
	# initialize arrays
	splash_positions.resize(splash_array_max_length)
	splash_positions.fill(Vector3(1.0, 1.0, 1.0))
	splash_times.resize(splash_array_max_length)
	splash_times.fill(1.0)
	
	timer = max_interval_btwn_splashes * 0.9 #make a splash at start

	# for some reason the player turns up as null even if preassigned?
	# manual fix........... ugh
	player = $"../player_avatar/CharacterBody3D"
	
	debug_sphere_material = debug_sphere.get_active_material(0)

func _physics_process(delta: float) -> void:	
	
	# get player position
	var world_playerpos = player.get_global_position()	
	
	# transform to local space of cylinder
	var local_playerpos = self.to_local(world_playerpos)
	print(local_playerpos);

	# snap to cylinder surface
	# im sure theres a better way to do this
	var direction_from_center = Vector2(local_playerpos.y, local_playerpos.z).normalized()
	var scaled_dir = direction_from_center * 0.5;
	local_playerpos = Vector3(local_playerpos.x, scaled_dir.x, scaled_dir.y);
	print(local_playerpos)


	# fix axes for rotation
	# WARNING THIS IS HARD CODED IF YOU ROTATE THE CYLINDER AGAIN ITS GONNA FUCK UP!
	var playerpos = Vector3(-local_playerpos.z, local_playerpos.x, -local_playerpos.y)


	
	# iterate through splash arrays
	for i in range(splash_array_max_length):
		# update time values in array
		# total lifetime of splash must be represented from 0 to 1
		splash_times[i] += delta / splash_duration
		
		# if a splash is done, reset it to 1
		if(splash_times[i] > 1.0):
			splash_times[i] = 1.0 
	
	# velocity disabled until riti can get me a function
	#var playervel = player.get_player_vel() 
	var playervel = 0;
	dist_traveled += playervel;
	
	timer += delta
	
	# make new splash based on either timer or distance travelled
	if (timer > max_interval_btwn_splashes || dist_traveled > max_distance_btwn_splashes):
		
		# add randomness to splashes
		playerpos += Vector3(randf_range(-0.01, 0.01), randf_range(-0.01, 0.01), randf_range(-0.01, 0.01))
		
		# add current player position to splash array
		splash_positions[curr_array_index] = playerpos
		
		# reset corresponding array timer
		splash_times[curr_array_index] = 0.0;
		
		# reset counters
		timer = 0;
		dist_traveled = 0;
		curr_array_index += 1;
		if(curr_array_index == splash_array_max_length):
			curr_array_index = 0;
	
	ground_material.set_shader_parameter("ripple_pos_arr", splash_positions)
	ground_material.set_shader_parameter("ripple_time_arr", splash_times)
