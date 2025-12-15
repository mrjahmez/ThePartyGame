extends Node

var current_room: Room
var room_map: Array[Room]
var inventory: Array[Item]
var characters: Array[Character]
var tick = 0

@onready var terminal: TextEdit = $Terminal
@onready var user_in: LineEdit = $UserIn
@onready var room_sprite: Sprite3D = $RoomSprite
@onready var room_model: MeshInstance3D = $RoomPlaceholder

func _ready() -> void:
	user_in.editable = false
	writeToTerminal("Generating house...")
	
	while room_map.size() < 12:
		room_map = HouseGenerator.new().generateHouse()
		
	writeToTerminal("Populating...")
	
	for room in room_map:
		for i in range(50 / room_map.size()):
			var new_name = "Person " + str(characters.size())
			var new_character = Character.new(room, new_name)
			room.addCharacter(new_character)
			characters.append(new_character)
			add_child(new_character)
			new_character.visible = false
			
	current_room = room_map[0]
	
	for room in room_map:
		writeToTerminal(room.getName() + "[" + str(room.getID()) + "] - " + str(room.getFloor()))
		
		for room_in in room.getLinkedRooms():
			writeToTerminal("Links to: " + room_in.getName() + "[" + str(room_in.getID()) + "] - " + str(room_in.getFloor()))
		writeToTerminal("")
	
	updatePeople()
	updateRoom()
	provideNav()
	user_in.editable = true
	
func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_text_submit"):
		user_in.editable = false
		var user_command = user_in.text
		handleCommand(user_command)
		user_in.text = ""
		user_in.editable = true
		
	if tick >= 10.0:
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
		
		updatePeople()
		updateRoom()
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
	room_sprite.texture = current_room.getTexture()
	
func updatePeople() -> void:
	for character in characters:
		character.updateCharacter()
		if character.getCurrentRoom() == current_room:
			character.visible = true
		else:
			character.visible = false
			var rand_x = randi_range(-18, 0)
			var rand_z = randi_range(-18, 0)
			character.positionSprite(rand_x, 2.5, rand_z)
	
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
