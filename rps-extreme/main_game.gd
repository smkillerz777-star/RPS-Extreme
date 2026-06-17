extends Control
var element_selected = 0
var match_game = 1
var turn = 1
var elements1 = "Player1: "
func _ready():
	$Label.text = "Player1 turn"
func _process(_delta: float) -> void:
	$Time_left.text = "Timer: " + str($Timer.time_left).substr(0,str($Timer.time_left).find(".")+2)
	if(element_selected>1):
		$Timer.stop()
		$Timer.timeout.emit()
		element_selected=0

func _on_timer_timeout() -> void:
	print(match_game)
	if(turn==1):
		$Label.text = "Player2 turn"
		turn = 2
		elements1 += "Player2: "
	else:
		$Label.text = "Player1 turn"
		turn = 1
		match_game += 1
		print(elements1)
		if(match_game==3):
			print("game over")
		elements1 = "Player1: "
	$Timer.start()
func _on_fire_pressed() -> void:
	element_selected+=1
	elements1 += "fire "
	turn_over($fire)
func _on_paper_pressed() -> void:
	element_selected+=1
	elements1 += "paper "
	turn_over($paper)
func _on_water_pressed() -> void:
	element_selected+=1
	elements1 += "water "
	turn_over($water)
func _on_earth_pressed() -> void:
	element_selected+=1
	turn_over($earth)
func _on_scissors_pressed() -> void:
	element_selected+=1
	elements1 += "scissors "
	turn_over($scissors)
func _on_air_pressed() -> void:
	element_selected+=1
	elements1 += "air "
	turn_over($air)
func _on_rock_pressed() -> void:
	element_selected+=1
	elements1 += "rock "
	turn_over($rock)

func turn_over(card):
	var tween = create_tween()
	tween.tween_property(card,"scale:x",0.0,0.15)
	if(card.get_child(0).get_node("back").visible == true):
		card.get_child(0).get_node("back").visible = false
		card.get_child(0).get_node(NodePath(card.name)).visible = true
	else:
		card.get_child(0).get_node("back").visible = true
		card.get_child(0).get_node(NodePath(card.name)).visible = false
	tween.tween_property(card,"scale:x",1.0,0.15)
