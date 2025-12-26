extends Node

var current_room: Room
var room_map: Array[Room]
var inventory: Array[Item]
var characters: Array[Character]
var known_characters: Array[Character]
var tick = 0
var cam_def: Transform3D
var current_tween: Tween
var is_focused = false
var focus_target: Character

@export var focus_time = 0.5
@export var focus_offset = 1.5
@export var character_positioning = 8
@export var tick_rate = 20.0

@onready var terminal: TextEdit = $Terminal
@onready var user_in: LineEdit = $UserIn
@onready var room_model: MeshInstance3D = $RoomPlaceholder
@onready var camera: Camera3D = $Camera3D
@onready var char_text: TextEdit = $CharacterText
@onready var query_opt: ItemList = $QueryList
@onready var char_list: ItemList = $CharacterList

func _ready() -> void:
	char_text.visible = false
	query_opt.visible = false
	char_list.visible = false
	terminal.visible = false
	user_in.visible = false
	cam_def = camera.transform
	resetCamera()
	user_in.editable = false
	writeToTerminal("Generating house...")
	
	while room_map.size() < 12:
		room_map = HouseGenerator.new().generateHouse()
		
	writeToTerminal("Populating...")
	
	for room in room_map:
		for i in range(50 / room_map.size()):
			var new_name = "Person " + str(characters.size())
			var new_character = Character.new(room, new_name, self)
			room.addCharacter(new_character)
			characters.append(new_character)
			add_child(new_character)
			new_character.billboard = 1
			if room.getID() == 0:
				new_character.visible = true
				var rand_x = randi_range(0, character_positioning)
				var rand_z = randi_range(0, character_positioning)
				new_character.positionSprite(rand_x * (-18 / character_positioning), 2.5, rand_z * (-18 / character_positioning))
			else:
				new_character.visible = false

			
	current_room = room_map[0]
	
	for room in room_map:
		writeToTerminal(room.getName() + "[" + str(room.getID()) + "] - " + str(room.getFloor()))
		writeToTerminal("Contains:")
		
		for character in room.getCharacters():
			writeToTerminal(" - " + character.getName())
			
		writeToTerminal("Links to:")
		
		for room_in in room.getLinkedRooms():
			writeToTerminal(" - " + room_in.getName() + "[" + str(room_in.getID()) + "] - " + str(room_in.getFloor()))
		writeToTerminal("")

	updateRoom()
	updatePeople()
	provideNav()
	user_in.editable = true
	
func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_text_submit"):
		
		user_in.editable = false
		var user_command = user_in.text
		handleCommand(user_command)
		user_in.text = ""
		user_in.editable = true
	elif Input.is_action_pressed("ui_cancel"):
		
		resetCamera()
	elif Input.is_action_just_released("ui_toggle"):
		
		terminal.visible = not terminal.visible
		user_in.visible = not user_in.visible
		
	if query_opt.is_selected(0):
		query_opt.deselect_all()
		char_list.clear()
		for character in getKnownCharacters():
			if character.getName() == focus_target.getName():
				continue
			char_list.add_item(character.getName())
		char_list.visible = true
	elif char_list.is_anything_selected():
		var selected = char_list.get_selected_items()
		char_list.deselect_all()
		var fin_opt = char_list.get_item_text(selected[0])
		focus_target.queryCharacter(fin_opt)
		
	if tick >= tick_rate:
		
		updatePeople()
		tick = 0
	
	tick += delta
		
func handleCommand(command: String) -> void:
	if command == "EXIT":
		get_tree().quit()
	elif command == "PPL":
		listPeople()
	elif command == "OBJ":
		listObjects()
	elif int(command) - 1 in range(current_room.getLinkedRooms().size()):
		current_room = current_room.getLinkedRooms()[int(command) - 1]
		
		updateRoom()
		updatePeople()
	else:
		writeToTerminal("Invalid input.")
		writeToTerminal("")
		
	provideNav()
	
func provideNav() -> void:
	writeToTerminal("You are in room: " + current_room.getName())
	writeToTerminal("You can move to: ")
	
	for i in range(current_room.getLinkedRooms().size()):
		if i == 0:
			writeToTerminal(str(i + 1) + ". " + current_room.getLinkedRooms()[i].getName() + " (Return)")
		else:
			writeToTerminal(str(i + 1) + ". " + current_room.getLinkedRooms()[i].getName())
	
	writeToTerminal("")
	
func writeToTerminal(text: String) -> void:
	terminal.insert_text_at_caret(text + "\n")
	terminal.scroll_vertical = float(terminal.get_line_count())
	
func updateRoom() -> void:
	#for room in room_map:
	#	room.updateDoors(room == current_room)
	resetCamera()
	
func updatePeople() -> void:
	for character in characters:
		character.updateCharacter()
		if character.getCurrentRoom() == current_room:
			character.visible = true
		else:
			character.visible = false
			var rand_x = randi_range(0, character_positioning)
			var rand_z = randi_range(0, character_positioning)
			character.positionSprite(rand_x * (-18 / character_positioning), 2.5, rand_z * (-18 / character_positioning))
	
func listPeople() -> void:
	if current_room.getCharacters().size() <= 0:
		writeToTerminal("No people in current room.")
		writeToTerminal("")
		return
		
	writeToTerminal("People in current room:")
	writeToTerminal("")
	for character in current_room.getCharacters():
		writeToTerminal(character.getName())
		
	writeToTerminal("")
	
func listObjects() -> void:
	if current_room.getInteractables().size() <= 0:
		writeToTerminal("No objects in current room.")
		writeToTerminal("")
		return
		
	writeToTerminal("Objects in current room:")
	writeToTerminal("")
	for interactable in current_room.getInteractables():
		writeToTerminal(interactable.getName())
		
	writeToTerminal("")
	
func resetCamera() -> void:
	if current_tween:
		current_tween.kill()
		
	current_tween = create_tween()
	
	current_tween.tween_property(camera, "transform", cam_def, focus_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	is_focused = false
	focus_target = null
	
func isFocused() -> bool:
	return is_focused
	
func focusOn(target: Node3D) -> void:
	if is_focused:
		return
	
	if target == null:
		return
		
	is_focused = true
	focus_target = target
	
	if not (target in known_characters):
		known_characters.append(target)
	
	if current_tween:
		current_tween.kill()
		
	var target_pos = target.global_position + getTargetPos(target)
	var target_basis = camera.global_transform.looking_at(target.global_position, Vector3.UP).basis
	
	current_tween = create_tween()
	current_tween.set_parallel()
	
	current_tween.tween_property(camera, "global_position", target_pos, focus_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	current_tween.tween_method(Callable(self, "tweenRotation"), camera.global_basis, target_basis, focus_time)
	
func tweenRotation(basis: Basis):
	camera.global_basis = basis
	
func getTargetPos(target: Node3D) -> Vector3:
	var x = camera.global_position.x - target.global_position.x
	var z = camera.global_position.z - target.global_position.z
	var angle = atan(z / x)
	x = focus_offset * cos(angle)
	z = focus_offset * sin(angle)
	
	var target_offset = Vector3(x, 1, z)
	
	return target_offset
	
func getKnownCharacters() -> Array[Character]:
	return known_characters
	
