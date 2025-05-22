extends SubViewport

@export var test_splash: Texture2D
@export var dampening: float
@export var velocity: float

@export var splash_source: Vector2
@export var splash_size: float

var buffer1: SubViewport
var buffer1Rect: ColorRect
var buffer2: SubViewport 
var buffer2Rect: ColorRect
var testColorRect: ColorRect

func _ready():
	buffer1 = $Buffer1Viewport
	buffer1Rect = $Buffer1Viewport/ColorRect
	buffer2 = $Buffer2Viewport
	buffer2Rect = $Buffer2Viewport/ColorRect
	testColorRect = $MainColorRect
	
	
	buffer1Rect.material.set_shader_parameter("buffer_texture", buffer2.get_texture())
	buffer2Rect.material.set_shader_parameter("buffer_texture", get_texture())
	
	testColorRect.material.set_shader_parameter("dampening", dampening)
	testColorRect.material.set_shader_parameter("velocity", velocity)
	testColorRect.material.set_shader_parameter("splash_source_pt", splash_source)
	testColorRect.material.set_shader_parameter("splash_size", 0)

	

func _physics_process(_delta: float) -> void:
	testColorRect.material.set_shader_parameter("splash_source_pt", splash_source)
	#print(splash_source)

func make_ripple():
	helper_make_ripple(.1)
	await get_tree().create_timer(.3).timeout

	helper_make_ripple(.1)
	await get_tree().create_timer(.3).timeout
	
	helper_make_ripple(.1)
	

func helper_make_ripple(time: float):
	testColorRect.material.set_shader_parameter("splash_size", splash_size)
	print("start")
	await get_tree().create_timer(time).timeout
	testColorRect.material.set_shader_parameter("splash_size", 0)
	print("stop")

func set_splash_source(location: Vector2):
	splash_source = location
