extends Sprite3D

class_name Character

var current_room: Room
var char_name: String
var area: Area3D
var collider: CollisionShape3D
var shape: BoxShape3D
var game_handler: Node
var focus_lock = false

func _init(start_room: Room, new_name: String, handler: Node) -> void:
	current_room = start_room
	char_name = new_name
	game_handler = handler

func _ready() -> void:
	texture = load("res://Textures/PersonSilhouette.png")
	setCollision()
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		focus_lock = false
	
func getCurrentRoom() -> Room:
	return current_room
	
func getName() -> String:
	return char_name
	
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
	
func onAreaInput(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Sprite clicked: ", char_name)
		game_handler.focusOn(self)
		focus_lock = true
	
