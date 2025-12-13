extends Node

class_name Interactable

var items: Array[Item]
var obj_name: String

func _init(new_name: String) -> void:
	obj_name = new_name
	
func getName() -> String:
	return obj_name
