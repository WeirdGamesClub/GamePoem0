extends Node

@export var primary_button: ColorButton
@export var secondary_button: ColorButton
@export var prompt_title: RichTextLabel
@export var drawingCanvas : DrawingCanvas

var is_drawing: bool = false

func _ready() -> void:
	#disable node tree
	get_child(0).set_process(4)
	get_child(0).hide()
	
	LevelSignal.connect("pickup_signal",start_drawing)

	
func _process(delta: float) -> void:
	return

	
func start_drawing(prompt: Dictionary) -> void:
	#open menu
	primary_button.set_color(prompt.primary)
	secondary_button.set_color(prompt.secondary)
	prompt_title.text = "Draw " + prompt.title
	
	drawingCanvas.start_drawing()
	
	#enable node tree
	get_child(0).set_process(0)
	get_child(0).show()
	is_drawing = true
	
	return
