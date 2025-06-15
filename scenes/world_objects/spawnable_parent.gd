extends Node3D

@export var prompt: PromptResource
@export var wave : int = 0
@export var NumRoundsToAppear: int = 0
@export var AdditionalFractionRound: float = 0.0
@export_group("Drawing Only")
@export var use_prompt_colors: bool = true
@export var primary_color: Color
@export var secondary_color: Color
@export var EnableCollision: bool

var child_artspawn: ArtSpawn
var grandchild: Node3D

func _ready() -> void:
	child_artspawn = self.get_child(0)
	child_artspawn.NumRoundsToAppear = NumRoundsToAppear
	child_artspawn.AdditionalFractionRound = AdditionalFractionRound
	child_artspawn.wave = wave
	
	grandchild = child_artspawn.get_child(0)
	grandchild.prompt = prompt
	
	if(grandchild.get_class() == "StaticBody3D"):
		child_artspawn.EnableCollision = EnableCollision
		if(use_prompt_colors == true):
			grandchild.primary_color = prompt.primary_color
			grandchild.secondary_color = prompt.secondary_color
		else: 
			grandchild.primary_color = primary_color
			grandchild.secondary_color = secondary_color
