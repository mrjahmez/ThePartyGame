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
var spawn_points: Dictionary[Node3D, Character]

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
	for child in model.find_child("SpawnPoints").get_children():
		if child:
			spawn_points[child] = null

func _ready() -> void:
	pass
	
func addRoom(room: Room):
	linked_rooms.append(room)
	
func addCharacter(character: Character):
	characters.append(character)
	
func addInteractable(obj: Interactable):
	interactables.append(obj)
	
func removeCharacter(character: Character):
	characters.erase(character)

func updateModel() -> void:
	model.visible = !model.visible
	
func onAreaInput(_camera: Camera3D, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		game_handler.moveRoom(collider, linked_rooms[0])
	
func updateCharacter(spawn: Node3D, character: Character) -> void:
	if spawn_points.get(spawn) == null:
		spawn_points[spawn] = character
		return
	spawn_points[spawn] = null
	
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
	
func getAvailableSpawns() -> Array[Node3D]:
	var available_spawns: Array[Node3D] = []
	for spawn in spawn_points.keys():
		if spawn == null:
			continue
		if spawn_points.get(spawn) == null:
			available_spawns.append(spawn)
	
	return available_spawns
