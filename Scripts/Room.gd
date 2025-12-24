extends Node

class_name Room

var linked_rooms: Array[Room]
var room_name: String
var room_id: int
var floor_num: int
var characters: Array[Character]
var interactables: Array[Interactable]
var model: MeshInstance3D

#var doors: Array[MeshInstance3D]
#var handler

func _init(name_to: String, id: int, floor_to: int = 0, rooms: Array[Room] = [], game_handler = null):
	room_name = name_to
	room_id = id
	floor_num = floor_to
	linked_rooms += rooms
	#handler = get_node_or_null("/root/GameHandler") # fix this to instantiate rooms
	#print(handler)

func _ready() -> void:
	pass
	
func addRoom(room: Room):
	linked_rooms.append(room)
	
func addCharacter(character: Character):
	characters.append(character)
	
func addInteractable(obj: Interactable):
	interactables.append(obj)
	
func removeCharacter(character_name: String):
	for character in characters:
		if character.getName() == character_name:
			characters.erase(character)
			break

#func updateDoors(is_room: bool = false) -> void:
#	if doors.size() == 0 or doors == null:
#		for i in range(linked_rooms.size()):
#			var new_door = MeshInstance3D.new()
#			#handler.add_child(new_door)
#			new_door.mesh = load("res://Models/Door.tres")
#			
#			new_door.global_position = Vector3(-19.0, 2.25, (18 / linked_rooms.size()) * -i)
#			doors.append(new_door)
#			
#	if is_room:
#		for door in doors:
#			door.visible = true
#	else:
#		for door in doors:
#			door.visible = false
	
func getName() -> String:
	return room_name
	
func getID() -> int:
	return room_id
	
func getFloor() -> int:
	return floor_num
	
func getLinkedRooms() -> Array[Room]:
	return linked_rooms
	
func getCharacters() -> Array[Character]:
	return characters
	
func getInteractables() -> Array[Interactable]:
	return interactables
