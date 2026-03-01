extends Control

func _ready():
	var p1_wins = GameState.p1_round_wins
	var p2_wins = GameState.p2_round_wins
	
	if p1_wins > p2_wins:
		$VBoxContainer/WinnerLabel.text = "PLAYER 1 (Prince) WINS THE MATCH!"
	elif p2_wins > p1_wins:
		$VBoxContainer/WinnerLabel.text = "PLAYER 2 (Narakasur) WINS THE MATCH!"
	else:
		$VBoxContainer/WinnerLabel.text = "IT'S A DRAW!"
	
	$VBoxContainer/ScoreLabel.text = "Score:  P1  " + str(p1_wins) + "  -  " + str(p2_wins) + "  P2"
	$VBoxContainer/MenuButton.pressed.connect(_on_menu_pressed)

func _on_menu_pressed():
	GameState.reset()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
