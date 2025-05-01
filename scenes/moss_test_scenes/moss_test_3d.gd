extends Node3D

signal painting_completed(painting: PackedByteArray, number: int)

var paintingNumber: int = 0

func  _ready() -> void:
	$TestDrawingUi.set_visible(false)	
	$NewPaintingButton.set_visible(true)

func accept_on_button_pressed() -> void:
	var drawnImageBuffer: PackedByteArray = $TestDrawingUi.finish_image()
	
	#UI cleanup.. I think
	$TestDrawingUi.release_focus() #theoretically releasing UI input but idk how this works really
	$TestDrawingUi.set_visible(false)
	
	painting_completed.emit(drawnImageBuffer, paintingNumber)
	
	#curretly painting number just increments in order of creation, maybe it shouldnt do that
	paintingNumber += 1 
	
	$NewPaintingButton.set_visible(true)

func new_painting_on_button_pressed() -> void:
	$TestDrawingUi.set_visible(true)
	$TestDrawingUi.setup_image()

	$NewPaintingButton.set_visible(false)
