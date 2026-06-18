extends Control

func _ready() -> void:
	$Play_Button.add_theme_font_size_override("font_size",global.font_size)
	$Instructions_Button.add_theme_font_size_override("font_size",global.font_size)
	$Setting_Button.add_theme_font_size_override("font_size",global.font_size)
	$Title.add_theme_font_size_override("font_size",global.heading_font_size)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_game.tscn")

func _on_instructions_button_pressed() -> void:
	get_tree().change_scene_to_file("res://instructions.tscn")


func _on_setting_button_pressed() -> void:
	get_tree().change_scene_to_file("res://settings.tscn")
