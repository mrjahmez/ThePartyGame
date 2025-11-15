extends Node

var current_room: Room
var room_map: Array[Room]
var inventory: Array[Item]

@onready var terminal: TextEdit = $Terminal
@onready var user_in: LineEdit = $UserIn
@onready var room_sprite: Sprite3D = $RoomSprite

func _ready() -> void:
	user_in.editable = false
	writeToTerminal("Generating house...")
	
	while room_map.size() < 12:
		room_map = HouseGenerator.new().generateHouse()
	
	current_room = room_map[0]
	
	for room in room_map:
		writeToTerminal(room.getName() + "[" + str(room.getID()) + "] - " + str(room.getFloor()))
		
		for room_in in room.getLinkedRooms():
			writeToTerminal("Links to: " + room_in.getName() + "[" + str(room_in.getID()) + "] - " + str(room_in.getFloor()))
		writeToTerminal("")
	
	updateRoom()
	provideNav()
	user_in.editable = true
	
func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_text_submit"):
		user_in.editable = false
		var user_command = user_in.text
		handleNav(user_command)
		user_in.text = ""
		user_in.editable = true
		
func handleNav(command: String) -> void:
	if command == "EXIT":
		get_tree().quit()
	elif int(command) - 1 in range(current_room.getLinkedRooms().size()):
		current_room = current_room.getLinkedRooms()[int(command) - 1]
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
