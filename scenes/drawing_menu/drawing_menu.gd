extends Node

@export var primary_button: ColorButton
@export var secondary_button: ColorButton
@export var prompt_title: RichTextLabel
@export var drawingCanvas : DrawingCanvas
@export var acceptPopup: Control

signal finish_drawing(texture:Texture2D)

var is_drawing: bool = false

var currentPrompt : PromptResource
var currentDrawing : Texture2D

func _ready() -> void:
	#disable node tree
	get_child(0).set_process(4)
	get_child(0).hide()
	
	LevelSignal.connect("pickup_signal",start_drawing)

	
func start_drawing(prompt: PromptResource) -> void:
	#open menu

	primary_button.set_color(prompt.primary_color)
	secondary_button.set_color(prompt.secondary_color)
	prompt_title.text = "Draw " + prompt.title
	
	
	currentPrompt = prompt
	
	currentPrompt.drawing = Texture2D.new()
	
	drawingCanvas.start_drawing(prompt.primary_color)
	
	#enable node tree
	get_child(0).set_process(0)
	get_child(0).show()
	is_drawing = true
	
	acceptPopup.set_process(false)
	acceptPopup.visible = false
	
	return
	
func query_accept()->void:
	acceptPopup.set_process(true)
	acceptPopup.visible = true
	drawingCanvas.set_process(false)
	currentDrawing = drawingCanvas.pull_drawing()
	emit_signal("finish_drawing",currentDrawing)
	
func save_drawing()->void:
	currentPrompt.set_drawing(currentDrawing)
	#TODO: close window an exit drawing mode
	drawingCanvas.set_process(true)
	get_child(0).set_process(false)
	get_child(0).hide()
	pass
