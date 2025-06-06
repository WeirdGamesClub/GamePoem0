extends Node3D

@export var prompt: PromptResource
@export var NumRoundsToAppear: int = 0
@export var AdditionalFractionRound: float = 0.0

var child_artspawn: Node3D
var grandchild: Node3D

func _ready() -> void:
	child_artspawn = self.get_child(0)
	child_artspawn.NumRoundsToAppear = NumRoundsToAppear
	child_artspawn.AdditionalFractionRound = AdditionalFractionRound
	
	grandchild = child_artspawn.get_child(0)
	grandchild.prompt = prompt
