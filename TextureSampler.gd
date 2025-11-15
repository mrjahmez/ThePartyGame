extends Node

class_name TextureSampler

@onready var textures: Array = []

func _init() -> void:
	var dir = DirAccess.open("res://Rooms/")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".png") or file.ends_with(".jpg") or file.ends_with(".webp"):
				textures.append(load("res://Rooms/" + file))
			file = dir.get_next()
		dir.list_dir_end()
				
func getTexture():
	return textures.pick_random()
