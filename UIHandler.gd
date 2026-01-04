extends Node3D

@onready var game_handler = $GameHandler
@onready var terminal = $Terminal
@onready var user_in = $UserIn
@onready var char_text = $CharacterText
@onready var query_list = $QueryList
@onready var char_list = $CharacterList

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
			char_text.visible = false
			query_list.visible = false
			char_list.visible = false
			char_text.text = ""
			
func writeToTerminal(text: String) -> void:
	terminal.insert_text_at_caret(text + "\n")
	terminal.scroll_vertical = float(terminal.get_line_count())
