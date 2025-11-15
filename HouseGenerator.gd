extends Node

class_name HouseGenerator

var room_map: Array[Room]
var total_rooms: int = 16
var num_rooms: int = 0
var room_id = 0
var room_names = [
	{
		"Bathroom": [[1], 2, []],
		"Kitchen": [[1, 2, 3], 1,
		["Dining Room", "Corridor", "Living Room", "Backyard"]],
		"Corridor": [[3, 4], 4,
		["Bathroom", "Kitchen", "Dining Room", "Living Room", "Backyard", "Stairway", "Bedroom", "Study"]],
		"Dining Room": [[2, 3], 1,
		["Kitchen", "Living Room", "Corridor", "Backyard"]],
		"Living Room": [[2, 3], 2,
		["Bathroom", "Kitchen", "Corridor", "Dining Room", "Backyard", "Stairway", "Study"]],
		"Backyard": [[1], 1, []],
		"Stairway": [[2], 1,
		["Corridor"]], 
		"Bedroom": [[1, 2], 3,
		["Bathroom", "Study"]],
		"Study": [[1], 2, []]
	},
	{
		"Bathroom": [[1], 1, []],
		"Corridor": [[3, 4], 3,
		["Bathroom", "Living Room", "Stairway", "Bedroom", "Study"]],
		"Living Room": [[2, 3], 2,
		["Bathroom", "Corridor", "Balcony", "Stairway", "Study"]],
		"Balcony": [[1], 2, []],
		"Stairway": [[2], 1,
		["Attic"]],
		"Bedroom": [[1, 2], 2,
		["Bathroom", "Study"]],
		"Study": [[1], 1, []]
	},
	{
		"Attic": [[1, 2], 1,
		["Rooftop"]],
		"Rooftop": [[1], 1, []]
	}
	]

func generateHouse() -> Array[Room]:
	var prev_room = Room.new("Porch", room_id, 0)
	room_id += 1
	room_map.append(prev_room)
	var next_room = Room.new("Corridor", room_id, 0)
	room_id += 1
	room_map.append(next_room)
	prev_room.addRoom(next_room)
	generateRooms(next_room, prev_room, 0)
	
	return room_map
	
func generateRooms(room_to_gen: Room, origin_room: Room, floor_num: int) -> void:
	room_to_gen.addRoom(origin_room)
	var rooms_to_gen = room_names[floor_num].get(room_to_gen.getName())[0].pick_random()
	
	#add back if room limitations are needed
	#if rooms_to_gen <= 1 or num_rooms >= total_rooms:
	#	return
	#	
	#if (rooms_to_gen + num_rooms) > total_rooms:
	#	rooms_to_gen = total_rooms - num_rooms
	#	
	#num_rooms += (rooms_to_gen - 1)
	
	for i in range(rooms_to_gen - 1):
		var next_floor = floor_num
		
		if room_to_gen.getName() == "Stairway":
			next_floor += 1
		
		var possible_rooms = room_names[floor_num].get(room_to_gen.getName())[2].size()
		var next_room_index = randi() % possible_rooms
		var next_room_name = room_names[floor_num].get(room_to_gen.getName())[2][next_room_index]
		var has_next_room = false
		
		for j in range(possible_rooms):
			if room_names[next_floor].get(next_room_name)[1] > 0:
				has_next_room = true
				break
				
			next_room_name = room_names[floor_num].get(room_to_gen.getName())[2][(next_room_index + j) % possible_rooms]
		
		if not has_next_room:
			return

		var room_mapping = room_names[next_floor].get(next_room_name)[0]
		var room_count = room_names[next_floor].get(next_room_name)[1] - 1
		var joinable_rooms = room_names[next_floor].get(next_room_name)[2]
		room_names[next_floor][next_room_name] = [room_mapping, room_count, joinable_rooms]

		var next_room = Room.new(next_room_name, room_id, next_floor)
		room_id += 1
		room_map.append(next_room)
		room_to_gen.addRoom(next_room)
		generateRooms(next_room, room_to_gen, next_floor)
	
	
