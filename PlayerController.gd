extends Node

var current_room: Room
var room_map: Array[Room]
var inventory: Array[Item]

@onready var terminal: TextEdit = self.get_child(0)

func _ready() -> void:
	#terminal.editable = false
	writeToTerminal("Generating house...")
	
	while room_map.size() < 12:
		room_map = HouseGenerator.new().generateHouse()
	
	current_room = room_map[0]
	
	for room in room_map:
		writeToTerminal(room.getName() + "[" + str(room.getID()) + "] - " + str(room.getFloor()))
		
		for room_in in room.getLinkedRooms():
			writeToTerminal("Links to: " + room_in.getName() + "[" + str(room_in.getID()) + "] - " + str(room_in.getFloor()))
		writeToTerminal("")
	
	#for room in room_map:
	#	print(room.getName() + "[" + str(room.getID()) + "] - " + str(room.getFloor()))
	#	
	#	for room_in in room.getLinkedRooms():
	#		print("Links to: " + room_in.getName() + "[" + str(room_in.getID()) + "] - " + str(room_in.getFloor()))
	#	print()
	
func _process(delta: float) -> void:
	pass
	
func writeToTerminal(text: String) -> void:
	terminal.text += text + "\n"
	
