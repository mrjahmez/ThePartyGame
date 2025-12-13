extends Node

class_name Person

var current_room: Room
var char_name: String
var t = 0

func _init(start_room: Room, new_name: String) -> void:
	current_room = start_room
	char_name = new_name
	
func getCurrentRoom(room: Room) -> Room:
	return current_room
	
func getName() -> String:
	return char_name
	
		
func updatePerson() -> void:
	if randi() % 3 == 0:
		var new_room = current_room.getLinkedRooms().pick_random()
		current_room.removePerson(getName())
		current_room = new_room
		new_room.addPerson(self)
