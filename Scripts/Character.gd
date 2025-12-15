extends Sprite3D

class_name Character

var current_room: Room
var char_name: String

func _init(start_room: Room, new_name: String) -> void:
	current_room = start_room
	char_name = new_name

func _ready() -> void:
	texture = load("res://Textures/PersonSilhouette.png")
	
func getCurrentRoom() -> Room:
	return current_room
	
func getName() -> String:
	return char_name
	
func positionSprite(in_x: int, in_y: int, in_z: int) -> void:
	transform.origin = Vector3(in_x, in_y, in_z)
	rotation = Vector3(0, 45, 0)
	
func updateCharacter() -> void:
	if randi() % 3 == 0:
		var new_room = current_room.getLinkedRooms().pick_random()
		current_room.removeCharacter(getName())
		current_room = new_room
		new_room.addCharacter(self)
