extends Resource

class_name PromptResource

@export var title : String = "default"
@export var primary_color : Color = Color.BLACK
@export	var secondary_color : Color = Color.WHITE
var drawing : Texture2D 

signal changed_drawing(texture:Texture2D)

func set_drawing(texture:Texture2D)-> void:
	drawing = texture
	emit_signal("changed_drawing", drawing)

func get_prompt() -> Dictionary:
	return {"title" = title, 
	"primary"= primary_color, 
	"secondary"= secondary_color,
	"drawing" = drawing}
