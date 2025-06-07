extends Node3D

func _ready() -> void:
	var test_array: Array[int]
	test_array.resize(5)
	print(test_array)
	print("size:" + str(test_array.size()))
	print("is_empty:" + str(test_array.is_empty()))
