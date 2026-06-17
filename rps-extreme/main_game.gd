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
	if(turn==1):
		$Label.text = "Player2 turn"
		turn = 2
		elements1 += "Player2: "
	else:
		$Label.text = "Player1 turn"
		turn = 1
		match_game += 1
		print(elements1)
		elements1 = "Player1: "
	$Timer.start()
func _on_paper_pressed() -> void:
	element_selected+=1
	elements1 += "paper "

func _on_scissors_pressed() -> void:
	element_selected+=1
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

#details
#we have rock paper scirssors fire water air laser
#rock crushes scirssors,put out fire,blocks laser rock wins
#rock covered by paper,drown in water,carried by air rock lose
#scissors cuts paper,reflect laser,cuts throw air scirssors win
#scirssors get crushed by rock,melts by fire,drown in water sccissors lose
#laser cuts air, evaporates water,passes through fire laser wins
#laser get reflected by scissors,blocked by rock,deflected by paper
#air shifts rock,extinguish fire,carries paper 
#air get bush bush by scissors,cutted by laser,dissolved in water
#fire burns paper,
#fire get extinguish by air,
#paper covers rock,becomes boat and float in water,
#paper get decayed by laser,cuts by scissors,get burned by fire
#water

#confirm things:
#rock defeated scissors
#scissores defeat paper
#paper defeats rock
#air defeates fire
#fire defeates laser,scissors,paper
#fire get defeated by rock,water,air
#water defeates fire
#laser get defeated by scissos,rock,paper

#order
#fire

#laser
#
#
#
#
