extends SubViewport

@export var test_splash: Texture2D
@export var dampening: float
@export var velocity: float

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
	
	make_ripple(4)
	#await get_tree().create_timer(8.5).timeout
	#make_ripple(.05)
	#await get_tree().create_timer(.4).timeout
	#make_ripple(.05)
	#await get_tree().create_timer(.3).timeout

func make_ripple(time: float):
	testColorRect.material.set_shader_parameter("splash_source", test_splash)
	await get_tree().create_timer(time).timeout
	testColorRect.material.set_shader_parameter("splash_source", null)
