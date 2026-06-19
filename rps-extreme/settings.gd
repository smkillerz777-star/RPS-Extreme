extends Control


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
	global.rounds = int($input1.text)
	global.card_selected = int($input2.text)
