extends Control


func _on_back_pressed() -> void:
	if($input1.text.is_valid_int() and $input2.text.is_valid_int() and int($input1.text)>0 and int($input2.text)>0):
		global.rounds = int($input1.text)
		global.card_selected = int($input2.text)
		get_tree().change_scene_to_file("res://main_menu.tscn")
	else:
		var tween = create_tween()
		tween.tween_property($warning,"modulate:a",1.0,0.5)
		tween.tween_interval(2.0)
		tween.tween_property($warning,"modulate:a",0.0,1)
