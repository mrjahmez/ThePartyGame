extends Sprite3D

class_name Character

var current_room: Room
var char_name: String
var area: Area3D
var collider: CollisionShape3D
var shape: BoxShape3D
var game_handler: Node
var focus_lock = false
var last_seen: Dictionary

var char_text
var query_opt
var char_list

func _init(start_room: Room, new_name: String, handler: Node) -> void:
	current_room = start_room
	char_name = new_name
	game_handler = handler

func _ready() -> void:
	texture = load("res://Textures/PersonSilhouette.png")
	char_text = game_handler.get_child(2)
	query_opt = game_handler.get_child(3)
	char_list = game_handler.get_child(4)
	setCollision()
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		focus_lock = false
		char_text.visible = false
		query_opt.visible = false
		char_list.visible = false
		char_text.text = ""
		
	
func getCurrentRoom() -> Room:
	return current_room
	
func getName() -> String:
	return char_name
	
func getLastSeen() -> Dictionary:
	return last_seen
	
func positionSprite(in_x: int, in_y: int, in_z: int) -> void:
	transform.origin = Vector3(in_x, in_y, in_z)
	
func updateCharacter() -> void:
	if focus_lock:
		return
		
	if randi() % 3 == 0:
		var new_room = current_room.getLinkedRooms().pick_random()
		current_room.removeCharacter(getName())
		current_room = new_room
		new_room.addCharacter(self)
		
	for character in current_room.getCharacters():
		if character == self:
			continue
		last_seen.set(character, current_room)
		
func setCollision() -> void:
	area = Area3D.new()
	area.name = "ClickArea"
	add_child(area)
	
	area.input_ray_pickable = true
	
	collider = CollisionShape3D.new()
	shape = BoxShape3D.new()
	
	shape.size = getSpriteWorldSize()
	collider.shape = shape
	
	area.add_child(collider)
	area.input_event.connect(onAreaInput)
	
func getSpriteWorldSize() -> Vector3:
	if texture == null:
		print("Texture error")
		return Vector3.ONE
		
	var tex_size = texture.get_size()
	var w = tex_size.x * pixel_size * scale.x
	var h = tex_size.y * pixel_size * scale.y
	
	return Vector3(w * 0.3, h * 1, 0.05)
	
func onAreaInput(_camera: Camera3D, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not game_handler.isFocused():
		game_handler.focusOn(self)
		focus_lock = true
		char_text.visible = true
		query_opt.visible = true
		char_text.text = getName() + ": Hello there!"
			
func queryCharacter(query: String) -> void:
	for character in getLastSeen().keys():
		if character.getName() == query:
			char_text.text = "I saw " + query + " in the " + last_seen.get(character).getName()
			return
	char_text.text = "I haven't seen them, sorry"
	return
	
