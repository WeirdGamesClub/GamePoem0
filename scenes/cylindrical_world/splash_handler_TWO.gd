extends Node3D
 
@export var player: Node3D
@export var ground_mesh: MeshInstance3D;
@export var max_interval_btwn_splashes: float = 2.1
@export var max_distance_btwn_splashes: float = 0.14
@export var splash_duration: float = 2
@export var splash_radius: float = 0.15
@export var splash_width: float = 0.01

var ground_material: Material

var splash_positions: Array[Vector3]
var splash_times: Array[float]

var prompts: Array[String]
var prompt_positions: Array[Vector3]
var prompt_times: Array[float]

# these numbers totaled = array length in shader
# this number has to be hard-coded to the shader so it's hard coded here too
var splash_array_max_length: int = 6
var prompt_array_max_length: int = 8

var active_ripples: int
var ripples_to_deactivate: Array[int]

var timer: float
var dist_traveled: float = 0;
var curr_array_index: int = 0;

func _ready() -> void:
	# set shader parameters from script variables
	ground_material = ground_mesh.get_active_material(0)
	ground_material.set_shader_parameter("rip_radius", splash_radius)
	ground_material.set_shader_parameter("rip_width", splash_width)
	
	# initialize arrays
	splash_positions.resize(splash_array_max_length)
	splash_positions.fill(Vector3(1.0, 1.0, 1.0))
	splash_times.resize(splash_array_max_length)
	splash_times.fill(1.0)
	
	timer = max_interval_btwn_splashes * 0.9 #make a splash at start

	# for some reason the player turns up as null even if preassigned?
	# manual fix........... ugh
	player = $"../player_avatar/CharacterBody3D"
	
	#LevelSignal.connect("prompt_removed", on_prompt_removed)
	#LevelSignal.connect("prompt_added", on_prompt_added)
	
func _physics_process(delta: float) -> void:	
	
	# get player position
	var world_playerpos = player.get_global_position()	

	# fix axes for rotation
	var playerpos = get_local_cylinder_surface(world_playerpos)

	# iterate through player splash arrays
	for i in range(splash_array_max_length):
		# update time values in array
		# total lifetime of splash must be represented from 0 to 1
		splash_times[i] += delta / splash_duration
		
		# if a splash is done, reset it to 1
		if(splash_times[i] > 1.0):
			splash_times[i] = 1.0 
	
	var playervel = player.get_speed() 
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
		
		#play SFX if moving
		if(playervel != 0):
			AudioSignal.foot_SFX.emit()
		
		# reset counters
		timer = 0;
		dist_traveled = 0;
		curr_array_index += 1;
		if(curr_array_index == splash_array_max_length):
			curr_array_index = 0;
	
	# update prompt splashes
	for i in range(prompt_times.size()):
		prompt_times[i] += delta / splash_duration
		if(prompt_times[i] > 1.0):
			prompt_times[i] = 0.0
	

	var combined_pos_array: Array[Vector3] = splash_positions.duplicate()
	combined_pos_array.append_array(prompt_positions)
	
	var combined_time_array: Array[float] = splash_times.duplicate()
	combined_time_array.append_array(prompt_times)
	
	ground_material.set_shader_parameter("ripple_pos_arr", combined_pos_array)
	ground_material.set_shader_parameter("ripple_time_arr", combined_time_array)
	ground_material.set_shader_parameter("active_ripples", combined_pos_array.size())

func on_prompt_added(reference: Node3D) -> void:
	# dont add if we're out of array space
	if(prompt_positions.size() > prompt_array_max_length):
		print("YOU FUCKED UP, MORE PROMPTS IN WORLD THAN PROMPT SPLASH ARRAY SPACE ")
		print("EXPAND THE PROMPT ARRAY PLEASE (CURRENTLY 8)")
	else:
		# only add if it's a prompt, not a drawing
		if (reference.get_class() == "Area3D"):
			if(reference.prompt != null):
				var ref_prompt = reference.prompt
				prompts.push_back(ref_prompt.title)
				
				var pos = get_local_cylinder_surface(reference.get_global_position())
				print(str(pos) + "add prompt pos")
				prompt_positions.push_back(pos)
				
				# add offset to timer so prompts don't have synchronized ripples
				var time_offset = float(prompt_times.size()) / float(prompt_array_max_length)
				prompt_times.push_back(time_offset)

func on_prompt_removed(reference: Node3D) -> void:
	# find index of prompt based on its position
	var ref_prompt = reference.prompt
	var index = prompts.find(ref_prompt.title)
	
	# remove from arrays
	prompt_positions.remove_at(index)
	prompt_times.remove_at(index)


# input a world position
# transforms to local position
# snaps to cylinder surface
# applies rotation
func get_local_cylinder_surface(pos: Vector3) -> Vector3:
	# transform to local space of cylinder
	var local = self.to_local(pos)
	
	
	# snap to cylinder surface
	# im sure theres a better way to do this
	var direction_from_center = Vector2(local.y, local.z).normalized()
	# radius = 0.5 of diameter 1. since we're in local space, scale is accounted for automatically
	var scaled_dir = direction_from_center * 0.5;
	var scaled_local = Vector3(local.x, scaled_dir.x, scaled_dir.y);
	
	# WARNING THIS ADJUSTMENT IS HARD CODED 
	# IF YOU ROTATE THE CYLINDER AGAIN ITS GONNA FUCK UP!
	var fix_axes = Vector3(-scaled_local.z, scaled_local.x, -scaled_local.y)
	
	return fix_axes
