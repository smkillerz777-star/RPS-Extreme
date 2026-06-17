extends Control
var element_selected = 0
var match_game = 1
var turn = 1
var elements1 = "Player1: "
func _ready():
	$Label.text = "Player1 turn"
	$water.pressed.connect(on_button_pressed.bind($water))
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
func _on_paper_pressed() -> void:
	element_selected+=1
	turn_over()
	elements1 += "paper "

func _on_scissors_pressed() -> void:
	element_selected+=1
	get_signal_list()
	elements1 += "scissors "

func _on_rock_pressed() -> void:
	element_selected+=1
	elements1 += "rock "

func _on_fire_pressed() -> void:
	element_selected+=1
	elements1 += "fire "

func _on_laser_pressed() -> void:
	element_selected+=1
	elements1 += "laser "

func _on_water_pressed() -> void:
	element_selected+=1
	elements1 += "water "

func _on_air_pressed() -> void:
	element_selected+=1
	elements1 += "air "

func on_button_pressed(button):
	print(button.name)

func turn_over():
	var tween = create_tween()
	tween.tween_property($paper,"scale:x",0.0,0.15)
	if($paper.get_child(0).get_node("back_side").visible == true):
		$paper.get_child(0).get_node("back_side").visible = false
		$paper.get_child(0).get_node("paper_card").visible = true
	else:
		$paper.get_child(0).get_node("back_side").visible = true
		$paper.get_child(0).get_node("paper_card").visible = false
	tween.tween_property($paper,"scale:x",1.0,0.15)