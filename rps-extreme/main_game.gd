extends Control
var element2_selected = 0
var max_element2_selected = 3
var match_game = 1
var turn = 1
var element2s1 = "Player1: "
var selected = []
var tween
func _ready():
	tween = create_tween()
	label_animation(global.player1+" turn")
	selection_start()
func _process(delta: float) -> void:
	global.time_past += delta
	$Time_left.text = "Timer: " + str($Timer.time_left).substr(0,str($Timer.time_left).find(".")+2)
	if(element2_selected>=max_element2_selected):
		$Timer.stop()
		$Timer.timeout.emit()
		element2_selected=0

func _on_timer_timeout() -> void:
	if(turn==1):
		turn = 2
		element2s1 += "Player2: "
		global.selected1 = selected
		selected = []
		selection_end(global.selected1)
		label_animation(global.player2+" turn")
		selection_start()
		$Timer.start()
		print(turn)
	else:
		global.selected2 = selected
		selection_end(global.selected2)
		mmatch()
		
func _on_fire_pressed() -> void:
	element2_selected+=1
	selected.append(0)
	turn_over($fire)
func _on_paper_pressed() -> void:
	element2_selected+=1
	selected.append(1)
	turn_over($paper)
func _on_water_pressed() -> void:
	element2_selected+=1
	selected.append(2)
	turn_over($water)
func _on_earth_pressed() -> void:
	element2_selected+=1
	selected.append(3)
	turn_over($earth)
func _on_scissors_pressed() -> void:
	element2_selected+=1
	selected.append(4)
	turn_over($scissors)
func _on_air_pressed() -> void:
	element2_selected+=1
	selected.append(5)
	turn_over($air)
func _on_rock_pressed() -> void:
	element2_selected+=1
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
	element2s1 = "Player1: "
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
	print(match(global.selected1[0],global.selected2[0]))

func match(element1,element2):
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
	return "0"
func label_animation(word):
	$Label.text = word
	$Label.visible = false
	tween.tween_property($Label,"theme_override_font_sizes/font_size",150,0.35)
	tween.tween_property($Label,"position",Vector2(80,250),0.35)
	tween.tween_property($Label,"visible",true,0.15)
	tween.tween_property($Label,"theme_override_font_sizes/font_size",16,0.15)
	tween.tween_property($Label,"position",Vector2(980,0),0.15)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
