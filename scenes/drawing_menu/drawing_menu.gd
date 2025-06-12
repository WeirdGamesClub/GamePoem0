extends Node

@export var primary_button: ColorButton
@export var secondary_button: ColorButton
@export var prompt_title: RichTextLabel
@export var drawingCanvas : DrawingCanvas
@export var acceptPopup: Control
@export var drawingPreview: TextureRect

signal finish_drawing(texture:Texture2D)

var is_drawing: bool = false

var currentPrompt : PromptResource
var currentDrawing : Texture2D

var _paper_SFX_player : AudioStreamPlayer3D

const primaryBackendColor: Color = Color(1.0, 0.0, 0.0, 1.0)

func _ready() -> void:
	#disable node tree
	get_child(0).set_process(4)
	get_child(0).hide()
	
	_paper_SFX_player = get_node("AudioStreamPlayer3D")
	
	LevelSignal.connect("pickup_signal",start_drawing)
	

func start_drawing(prompt: PromptResource) -> void:
	#open menu

	primary_button.set_color(prompt.primary_color)
	secondary_button.set_color(prompt.secondary_color)
	prompt_title.text = "Draw " + prompt.title
	
	
	currentPrompt = prompt
	
	currentPrompt.drawing = Texture2D.new()
	
	drawingCanvas.start_drawing(primaryBackendColor)
	
	#enable node tree
	get_child(0).set_process(0)
	get_child(0).show()
	is_drawing = true
	InputManager.input_mode = InputManager.mode.DRAWING
	
	#play SFX
	_paper_SFX_player.play()
	
	acceptPopup.set_process(false)
	acceptPopup.visible = false
	
	# setup canvas shaders to display colors
	drawingCanvas.material.set_shader_parameter("primary_color", prompt.primary_color)
	drawingCanvas.material.set_shader_parameter("secondary_color", prompt.secondary_color)
	drawingPreview.material.set_shader_parameter("primary_color", prompt.primary_color)
	drawingPreview.material.set_shader_parameter("secondary_color", prompt.secondary_color)
	
	return
	
func query_accept()->void:
	acceptPopup.set_process(true)
	acceptPopup.visible = true
	drawingCanvas.set_process(false)
	currentDrawing = drawingCanvas.pull_drawing()
	emit_signal("finish_drawing",currentDrawing)
	
func save_drawing()->void:
	currentPrompt.set_drawing(currentDrawing)
	InputManager.input_mode = InputManager.mode.WALKING
	
	_paper_SFX_player.play()
	
	#close window
	drawingCanvas.set_process(true)
	get_child(0).set_process(false)
	get_child(0).hide()
	pass
