extends Control


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_backward_pressed() -> void:
	$forward.visible = true
	if($page2.visible == true):
		$page1.visible = true
		$page2.visible = false
		$backward.visible = false
	if($page3.visible == true):
		$page2.visible = true
		$page3.visible = false

func _on_forward_pressed() -> void:
	$backward.visible = true
	if($page1.visible == true):
		$page1.visible = false
		$page2.visible = true
	elif($page2.visible == true):
		$page2.visible = false
		$page3.visible = true
		$forward.visible = false
