extends Resource

class_name PromptResource

@export var title : String = "default"
@export var primary_color : Color = Color.BLACK
@export	var secondary_color : Color = Color.WHITE

func get_prompt() -> Dictionary:
	return {"title" = title, 
	"primary"= primary_color, 
	"secondary"= secondary_color}
