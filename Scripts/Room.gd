extends Node

class_name Room

var linked_rooms: Array[Room]
var room_name: String
var room_id: int
var floor_num: int
var people: Array[Person]
var interactables: Array[Interactable]
var texture: Texture2D
var model: MeshInstance3D

func _init(name_to: String, id: int, floor_to: int = 0, rooms: Array[Room] = []):
	room_name = name_to
	room_id = id
	floor_num = floor_to
	linked_rooms += rooms
	texture = TextureSampler.new().getTexture()
	
func addRoom(room: Room):
	linked_rooms.append(room)
	
func addPerson(person: Person):
	people.append(person)
	
func addInteractable(obj: Interactable):
	interactables.append(obj)
	
func removePerson(person_name: String):
	for person in people:
		if person.getName() == person_name:
			people.erase(person)
			break
	
func getName() -> String:
	return room_name
	
func getID() -> int:
	return room_id
	
func getFloor() -> int:
	return floor_num
	
func getLinkedRooms() -> Array[Room]:
	return linked_rooms
	
func getTexture() -> Texture2D:
	return texture
	
func getPeople() -> Array[Person]:
	return people
	
func getInteractables() -> Array[Interactable]:
	return interactables
