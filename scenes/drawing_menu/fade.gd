extends Node
class_name ControlFade
@export var control : Control
@export var drawing: DrawingCanvas

var fade_time : float =1 

enum {IN,OUT,IDLE}
var _state = IDLE

var _timer : float = 0
var _alpha : float

func _process(delta: float) -> void:
	if(_state == IDLE): return
	
	_timer += delta
	
	match(_state):
		OUT: 
			if(_timer >= fade_time):
				_state = IDLE
				control.modulate = Color.TRANSPARENT
			_alpha = lerp(_alpha,0.0,ease(_timer/fade_time,3))

		IN: 
			if(_timer >= fade_time):
				_state = IDLE
				control.modulate = Color.WHITE
			_alpha = lerp(_alpha,1.0,ease(_timer/fade_time,3))

	control.modulate = Color(1.0,1.0,1.0,_alpha)
	drawing.material.set_shader_parameter("alpha", _alpha)


func fade_in(c : Control, time: float = 1 ) -> void:
	control = c
	fade_time = time
	_timer = 0
	_state = IN
	
func fade_out(c : Control,time: float = 1) -> void:
	control = c
	fade_time = time
	_timer = 0
	_state = OUT
