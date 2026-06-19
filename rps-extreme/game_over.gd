extends Control

func _ready():
    $Label2.text = global.winner.to_upper() + " WON"

func _on_button_pressed() -> void:
    global.score1 = 0
    global.score2 = 0
    global.time_past = 0
    global.again = true
    get_tree().change_scene_to_file("res://main_game.tscn")


func _on_button_2_pressed() -> void:
    get_tree().change_scene_to_file("res://main_menu.tscn")
