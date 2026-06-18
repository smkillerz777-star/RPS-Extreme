extends Control
var element_selected = 0
var max_element_selected = 1
var match_game = 1
var max_match_game = 1
var turn = 1
var selected = []
var tween
var score1 = 0
var score2 = 0
func _ready():
	tween = create_tween()
	label_animation(global.player1+" turn")
	selection_start()
func _process(delta: float) -> void:
	global.time_past += delta
	$Time_left.text = "Timer: " + str($Timer.time_left).substr(0,str($Timer.time_left).find(".")+2)
	if(element_selected>=max_element_selected):
		$Timer.stop()
		$Timer.timeout.emit()
		element_selected=0

func _on_timer_timeout() -> void:
	if(turn==1):
		turn = 2
		global.selected1 = selected
		selected = []
		selection_end(global.selected1)
		label_animation(global.player2+" turn")
		selection_start()
		$Timer.start()
	else:
		global.selected2 = selected
		selected = []
		turn = 1
		match_game+=1
		selection_end(global.selected2)
		mmatch()
		
func _on_fire_pressed() -> void:
	element_selected+=1
	selected.append(0)
	turn_over($fire)
func _on_paper_pressed() -> void:
	element_selected+=1
	selected.append(1)
	turn_over($paper)
func _on_water_pressed() -> void:
	element_selected+=1
	selected.append(2)
	turn_over($water)
func _on_earth_pressed() -> void:
	element_selected+=1
	selected.append(3)
	turn_over($earth)
func _on_scissors_pressed() -> void:
	element_selected+=1
	selected.append(4)
	turn_over($scissors)
func _on_air_pressed() -> void:
	element_selected+=1
	selected.append(5)
	turn_over($air)
func _on_rock_pressed() -> void:
	element_selected+=1
	selected.append(6)
	turn_over($rock)

func turn_over(card):
	if(tween == null or not tween.is_valid()):
		tween = create_tween()
	tween.tween_property(card,"scale:x",0.0,0.15)
	if(card.get_child(0).get_node("back").visible == true):
		tween.tween_property(card.get_child(0).get_node("back"),"visible",false,0.01)
		tween.tween_property(card.get_child(0).get_node(NodePath(card.name)),"visible",true,0.01)
	else:
		tween.tween_property(card.get_child(0).get_node("back"),"visible",true,0.01)
		tween.tween_property(card.get_child(0).get_node(NodePath(card.name)),"visible",false,0.01)
	tween.tween_property(card,"scale:x",1.0,0.15)

func selection_start():
	var pos = Vector2.ZERO
	for i in range(4,11):
		pos.y = ((i/4)-1)*(340)+355
		if i<8:
			pos.x = (i-4)*(250)+240
		else:
			pos.x = (i-8)*(250)+365
		tween.tween_property(get_child(i),"position",pos,0.15)
		tween.tween_property(get_child(i),"rotation",0,0.15)
		turn_front(get_child(i))
	$Time_left.visible = true
	$Label.visible = true
	$Timer.start()

func selection_end(selected_cards):
	$Time_left.visible = false
	$Label.visible = false
	for i in range(0,7):
		if(selected_cards.find(i)==-1):
			turn_back(get_child(i+4))
	for i in range(4,11):
		tween.tween_property(get_child(i),"position",Vector2(615,815),0.15)

func turn_front(card):
	if(tween == null or not tween.is_valid()):
		tween = create_tween()
	tween.tween_property(card,"scale:x",0.0,0.15)
	tween.tween_property(card.get_child(0).get_node("back"),"visible",false,0.01)
	tween.tween_property(card.get_child(0).get_node(NodePath(card.name)),"visible",true,0.01)
	tween.tween_property(card,"scale:x",1.0,0.15)
	
func turn_back(card):
	if(tween == null or not tween.is_valid()):
		tween = create_tween()
	tween.tween_property(card,"scale:x",0.0,0.15)
	tween.tween_property(card.get_child(0).get_node("back"),"visible",true,0.01)
	tween.tween_property(card.get_child(0).get_node(NodePath(card.name)),"visible",false,0.01)
	tween.tween_property(card,"scale:x",1.0,0.15)
	
func mmatch():
	print(global.selected1)
	print(global.selected2)
	for i in range(max_element_selected):
		if(fight(global.selected1[i],global.selected2[i])==global.selected1[i]):
			score1+=1
		elif(fight(global.selected1[i],global.selected2[i])==global.selected2[i]):
			score2+=1
	print(score1)
	print(score2)
	if(score1>score2):
		label_animation(global.player1 + " won")
		global.score1 += 1
	elif(score2>score1):
		label_animation(global.player2 + " won")
		global.score2 += 1
	else:
		label_animation("tie")
	if(match_game<=max_match_game):
		label_animation(global.player1 + " turn")
		score1 = 0
		score2 = 0
		selection_start()
	else: 
		if(global.score1>global.score2):
			global.winner = global.player1
			game_over()
		elif(global.score2>global.score1):
			global.winner = global.player2
			game_over()
		else:
			label_animation(global.player1 + " turn")
			score1 = 0
			score2 = 0
			selection_start()

func fight(element1,element2):
	if(element1==0):
		if(element2==1 or element2==2 or element2==4):
			return element1
		elif(element2==3 or element2==5 or element2==6):
			return element2
		else:
			return null
	elif(element1==1):
		if(element2==2 or element2==3 or element2==5):
			return element1
		elif(element2==4 or element2==6 or element2==0):
			return element2
		else:
			return null
	elif(element1==2):
		if(element2==3 or element2==4 or element2==6):
			return element1
		elif(element2==5 or element2==0 or element2==1):
			return element2
		else:
			return null
	elif(element1==3):
		if(element2==4 or element2==5 or element2==0):
			return element1
		elif(element2==6 or element2==1 or element2==2):
			return element2
		else:
			return null
	elif(element1==4):
		if(element2==5 or element2==6 or element2==2):
			return element1
		elif(element2==1 or element2==3 or element2==4):
			return element2
		else:
			return null
	elif(element1==5):
		if(element2==6 or element2==0 or element2==2):
			return element1
		elif(element2==1 or element2==3 or element2==4):
			return element2
		else:
			return null
	elif(element1==6):
		if(element2==0 or element2==1 or element2==3):
			return element1
		elif(element2==2 or element2==4 or element2==5):
			return element2
		else:
			return null
	return null
func label_animation(word):
	tween.tween_property($Label,"text",word,0.01)
	$Label.visible = false
	tween.tween_property($Label,"theme_override_font_sizes/font_size",150,0.35)
	tween.tween_property($Label,"position",Vector2(80,250),0.35)
	tween.tween_property($Label,"visible",true,0.15)
	tween.tween_property($Label,"theme_override_font_sizes/font_size",16,0.15)
	tween.tween_property($Label,"position",Vector2(980,0),0.15)

func game_over():
	get_tree().change_scene_to_file("res://game_over.tscn")
