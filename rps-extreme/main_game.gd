extends Control
var element_selected = 0
var max_element_selected = 3
var match_game = 1
var max_match_game = 3
var turn = 1
var selected = []
var tween
var score1 = 0
var score2 = 0
var modifier_used1 = false
var modifier_used2 = false
var playable_cards1 = []
var playable_cards2 = []
var current_cards = []
var game_started = false
var card_enabled = false
var game_ended = false
var game_paused = false
var is_modifier_mode = true
const cardScene = preload("res://card.tscn")
func _ready():
	card_disable()
	#add_modifier("hehe")
	if(global.again):
		game_start()
func _process(delta: float) -> void:
	global.time_past += delta
	if((tween == null or not tween.is_valid()) and game_started and not game_paused):
		card_enable()
	if((tween == null or not tween.is_valid()) and game_ended):
		get_tree().change_scene_to_file("res://game_over.tscn")
	if(card_enabled and tween != null and tween.is_valid() and game_started):
		card_disable()
	if(element_selected>=max_element_selected):
		_on_timer_timeout()
		element_selected=0
	max_element_selected = global.card_selected
	max_match_game = global.rounds

func _on_timer_timeout() -> void:
	if(turn==1):
		turn = 2
		current_cards = playable_cards2
		global.selected1 = selected
		selected = []
		selection_end(global.selected1)
		label_animation(global.player2+" turn",0.5)
		selection_start()
	else:
		global.selected2 = selected
		selected = []
		current_cards = playable_cards1
		turn = 1
		match_game+=1
		$Label3.text = "Round: " + str(match_game)
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
	for i in current_cards.size():
		pos.y = (i/4)*(340)+355
		if(is_modifier_mode):
			pos.x = i*250+240
		else:
			if i<4:
				pos.x = i*250+240
			else:
				pos.x = i*250+365
		tween.tween_property(current_cards[i],"position",pos,0.15)
		tween.tween_property(current_cards[i],"rotation",0,0.15)
		turn_front(current_cards[i])
	$Label.visible = true

func selection_end(selected_cards):
	for i in current_cards.size():
		if(selected_cards.find(i)==-1):
			turn_back(current_cards[i])
	for i in current_cards.size():
		var angle = (i-4)*5/180.0*PI
		tween.tween_property(current_cards[i],"rotation",angle,0.15)
		tween.tween_property(current_cards[i],"position",Vector2(615,815),0.15)

func turn_front(card):
	if(tween == null or not tween.is_valid()):
		tween = create_tween()
	tween.tween_property(card,"scale:x",0.0,0.1)
	tween.tween_property(card.get_child(0).get_node("back"),"visible",false,0.01)
	tween.tween_property(card.get_child(0).get_node(NodePath(card.name)),"visible",true,0.01)
	tween.tween_property(card,"scale:x",1.0,0.1)
	
func turn_back(card):
	if(tween == null or not tween.is_valid()):
		tween = create_tween()
	tween.tween_property(card,"scale:x",0.0,0.1)
	tween.tween_property(card.get_child(0).get_node("back"),"visible",true,0.01)
	tween.tween_property(card.get_child(0).get_node(NodePath(card.name)),"visible",false,0.01)
	tween.tween_property(card,"scale:x",1.0,0.1)
	
func mmatch():
	for i in range(max_element_selected):
		if(fight(global.selected1[i],global.selected2[i])==global.selected1[i]):
			print_description(global.selected1[i],global.selected2[i])
			score1+=1
		elif(fight(global.selected1[i],global.selected2[i])==global.selected2[i]):
			print_description(global.selected2[i],global.selected1[i])
			score2+=1
	if(score1>score2):
		label_animation(global.player1 + " won",0.5)
		global.score1 += 1
	elif(score2>score1):
		label_animation(global.player2 + " won",0.5)
		global.score2 += 1
	else:
		label_animation("tie",0.5)
	$Label2.text = "Score: " + str(global.score1) + ":" + str(global.score2)
	if(match_game<=max_match_game):
		label_animation(global.player1 + " turn",0.5)
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
			label_animation(global.player1 + " turn",0.5)
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
		elif(element2==1 or element2==3 or element2==0):
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
func label_animation(word,duration,size_font=150):
	tween.tween_property($Label,"text",word,0.01)
	tween.tween_property($Label,"theme_override_font_sizes/font_size",size_font,0.35)
	tween.tween_property($Label,"position",Vector2(80,250),0.35)
	tween.tween_interval(duration)
	tween.tween_property($Label,"theme_override_font_sizes/font_size",16,0.15)
	tween.tween_property($Label,"position",Vector2(980,0),0.35)

func game_over():
	game_ended = true
func game_start():
	game_started = true
	$Label2.visible = true
	$Label3.visible = true
	for i in range(3,11):
		get_child(i).visible = true
	label_animation(global.player1+" turn",0.5)
	selection_start()

func _on_start_pressed() -> void:
	if($input1.text=="" or $input2.text==""):
		return
	global.player1 = $input1.text
	global.player2 = $input2.text
	$start.visible = false
	$input1.visible = false
	$input2.visible = false
	$player1.visible = false
	$player2.visible = false
	tween = create_tween()
	current_cards = $modifiers.get_children()
	cards_show()
	selection_start()

func  card_enable():
	for i in current_cards.size():
		current_cards[i].get_child(1).disabled = false
	card_enabled = true

func  card_disable():
	for i in current_cards.size():
		current_cards[i].get_child(1).disabled = true
	card_enabled = false

func print_description(winner,loser):
	var offset = 0
	if(loser<winner):
		if(winner==3 or winner==4):
			offset = 2
		elif(winner==5):
			if(loser==0):
				offset = 1
			else:
				offset = 2
		else:
			if(loser==3):
				offset = 2
			else:
				offset = loser
	else:
		if((loser-winner)==4):
			offset = 2
		else:
			offset = (loser-winner-1)
	label_animation(global.description[(winner)*3+offset],1,70)


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_back_pressed() -> void:
	var tween2 = create_tween()
	if(tween!=null and tween.is_valid()):
		tween.pause()
	$resume.visible = true
	$exit.visible = true
	$back.visible = false
	card_disable()
	tween2.tween_property($resume,"position:x",0,0.3)
	tween2.tween_property($exit,"position:x",0,0.3)
	game_paused = true


func _on_resume_pressed() -> void:
	var tween2 = create_tween()
	if(tween!=null and tween.is_valid()):
		tween.play()
	card_enable()
	$back.visible = true
	tween2.tween_property($resume,"position:x",-183,0.3)
	tween2.tween_property($exit,"position:x",-95,0.3)
	tween2.tween_property($exit,"visible",false,0.01)
	tween2.tween_property($resume,"visible",false,0.01)
	game_paused = false

func add_modifier(card_name):
	var card = Node2D.new()
	card.add_child(cardScene.instantiate())
	card.add_child(Button.new())
	card.name = card_name
	add_child(card)

func cards_show():
	var i = 0
	for card in current_cards:
		card.visible = true
		card.position = Vector2(615,1015)
		card.rotation = -15/180.0*PI
		i+=1
	i = 0
	for card in current_cards:
		if(i==0):
			tween.tween_property(card,"position",Vector2(615,815),0.3)
		else:
			tween.parallel().tween_property(card,"position",Vector2(615,815),0.3)
		i+=1
	i=0
	for card in current_cards:
		if(i==0):
			tween.tween_property(card,"rotation",-15/180.0*PI,0)
		else:
			tween.parallel().tween_property(card,"rotation",(-15 + i*15)/180.0*PI,0.1*i)
		i+=1

func cards_hide():
	var i =0
	for card in current_cards:
		if(i==0):
			tween.tween_property(card,"rotation",0,0)
		else:
			tween.parallel().tween_property(card,"rotation",0,0.1*i)
		i+=1
	i=0
	for card in current_cards:
		if(i==0):
			tween.tween_property(card,"position",Vector2(615,1015),0.3)
		else:
			tween.parallel().tween_property(card,"position",Vector2(615,1015),0.3)
		i+=1

func _on_lock_pressed() -> void:
	pass # Replace with function body.


func _on_change_pressed() -> void:
	pass # Replace with function body.


func _on_plus_one_pressed() -> void:
	pass # Replace with function body.
