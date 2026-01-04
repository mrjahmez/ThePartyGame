extends Node

class_name Room

var linked_rooms: Array[Room]
var room_name: String
var room_id: int
var floor_num: int
var characters: Array[Character]
var interactables: Array[Interactable]
var model
var collider
var game_handler

func _init(name_to: String, id: int, floor_to: int = 0, rooms: Array[Room] = [], game_model = null, handler = null):
	room_name = name_to
	room_id = id
	floor_num = floor_to
	linked_rooms += rooms
	model = game_model
	game_handler = handler
	model.visible = false
	collider = model.find_child("CollisionArea")
	if collider:
		collider.input_ray_pickable = true
		collider.input_event.connect(onAreaInput)

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

func updateModel() -> void:
	model.visible = !model.visible
	
func onAreaInput(_camera: Camera3D, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		game_handler.moveRoom(collider, linked_rooms[0])
	
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
