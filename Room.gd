extends Node

class_name Room

var linked_rooms: Array[Room]
var room_name: String
var room_id: int
var floor_num: int
var people: Array[Person]

func _init(name_to: String, id: int, floor_to: int = 0, rooms: Array[Room] = []):
	room_name = name_to
	room_id = id
	floor_num = floor_to
	linked_rooms += rooms
	
func addRoom(room: Room):
	linked_rooms.append(room)
	
func getName() -> String:
	return room_name
	
func getID() -> int:
	return room_id
	
func getFloor() -> int:
	return floor_num
	
func getLinkedRooms() -> Array[Room]:
	return linked_rooms
