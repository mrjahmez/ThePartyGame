extends Node

class_name HouseGenerator

var room_map: Array[Room]
var total_rooms: int = 16
var num_rooms: int = 0
var room_id = 0

var room_config_path = "res://Config/HouseGenConfig.json"
var room_config_file = FileAccess.open(room_config_path, FileAccess.READ)
var room_config_text = room_config_file.get_as_text()
var room_config_data = JSON.parse_string(room_config_text)

func generateHouse() -> Array[Room]:
	var prev_room = Room.new("Porch", room_id, 0)
	room_id += 1
	room_map.append(prev_room)
	var next_room = Room.new("Corridor", room_id, 0)
	room_id += 1
	room_map.append(next_room)
	prev_room.addRoom(next_room)
	generateRooms(next_room, prev_room, 0)
	
	for room in room_map:
		if room.getID() == 0:
			continue
		for i in range(room_config_data[room.getFloor()].get(room.getName())[3].size()):
			room.addInteractable(Interactable.new(room_config_data[room.getFloor()].get(room.getName())[3][i]))
	
	return room_map
	
func generateRooms(room_to_gen: Room, origin_room: Room, floor_num: int) -> void:
	room_to_gen.addRoom(origin_room)
	var rooms_to_gen = room_config_data[floor_num].get(room_to_gen.getName())[0].pick_random()
	
	for i in range(rooms_to_gen - 1):
		var next_floor = floor_num
		
		if room_to_gen.getName() == "Stairway":
			next_floor += 1
		
		var possible_rooms = room_config_data[floor_num].get(room_to_gen.getName())[2].size()
		var next_room_index = randi() % possible_rooms
		var next_room_name = room_config_data[floor_num].get(room_to_gen.getName())[2][next_room_index]
		var has_next_room = false
		
		for j in range(possible_rooms):
			if room_config_data[next_floor].get(next_room_name)[1] > 0:
				has_next_room = true
				break
				
			next_room_name = room_config_data[floor_num].get(room_to_gen.getName())[2][(next_room_index + j) % possible_rooms]
		
		if not has_next_room:
			return

		var room_mapping = room_config_data[next_floor].get(next_room_name)[0]
		var room_count = room_config_data[next_floor].get(next_room_name)[1] - 1
		var joinable_rooms = room_config_data[next_floor].get(next_room_name)[2]
		var room_objs = room_config_data[next_floor].get(next_room_name)[3]
		room_config_data[next_floor][next_room_name] = [room_mapping, room_count, joinable_rooms, room_objs]

		var next_room = Room.new(next_room_name, room_id, next_floor)
		room_id += 1
		room_map.append(next_room)
		room_to_gen.addRoom(next_room)
		generateRooms(next_room, room_to_gen, next_floor)
