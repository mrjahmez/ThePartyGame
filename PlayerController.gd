extends Node

var current_room: Room
var room_map: Array[Room]

func _ready() -> void:
	while room_map.size() < 12:
		room_map = HouseGenerator.new().generateHouse()
	
	current_room = room_map[0]
	
	for room in room_map:
		print(room.getName() + "[" + str(room.getID()) + "] - " + str(room.getFloor()))
		
		for room_in in room.getLinkedRooms():
			print("Links to: " + room_in.getName() + "[" + str(room_in.getID()) + "] - " + str(room_in.getFloor()))
		print()
	
	
